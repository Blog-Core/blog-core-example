:- module(post, [
    send_post/1, % +Slug
    send_tag/1,  % +Tag
    send_all_posts/0
]).

/** <module> Post/tag handlers */

:- use_module(library(http/http_wrapper)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(docstore)).
:- use_module(library(sort_dict)).
:- use_module(library(dict_schema)).
:- use_module(library(bc/bc_view)).
:- use_module(library(st/st_expr)).

:- use_module(config).

%! send_post(+Slug) is det.
%
% Replies with the given post page
% (identified by slug). Responds 404
% when the post is not found.

send_post(Slug):-
    (   ds_find(entry, slug=Slug, [Post])
    ->  post_comments(Post.'$id', Comments),
        ds_col_get(user, Post.author, Author),
        bc_view_send(views/post, _{
            post: Post,
            comments: Comments,
            title: Post.title,
            description: Post.description,
            author: Author
        })
    ;   http_current_request(Request),
        http_404([], Request)).

post_comments(Id, Sorted):-
    ds_find(comment, post=Id, Comments),
    sort_dict(date, asc, Comments, Sorted).

%! send_all_posts is det.
%
% Responds page with the list of all
% published posts.

send_all_posts:-
    ds_find(entry, (type=post, published=true),
        [title, date_published, tags, slug], Posts),
    sort_dict(date_published, desc, Posts, Sorted),
    bc_view_send(views/posts, _{
        posts: Sorted,
        title: 'All posts',
        description: 'All posts of this blog'
    }).

%! send_tag(+Tag) is det.
%
% Responds with all published posts
% tagged with the given tag. Responds
% 404 when the given tag has no published
% posts.

send_tag(Tag):-
    (   ds_find(entry, (published=true, member(Tag, tags)),
            [title, date_published, tags, slug], Posts),
        Posts = [_|_]
    ->  sort_dict(date_published, desc, Posts, Sorted),
        atom_concat('Posts related to ', Tag, Title),
        bc_view_send(views/tag, _{
            title: Title,
            posts: Sorted,
            description: Title
        })
    ;   http_current_request(Request),
        http_404([], Request)).

% Function to format dates in templates.
% Format %F produces date in the YYYY-MM-DD format.

:- st_set_function(format_date, 1, format_date).

format_date(Date, Formatted):-
    format_time(atom(Formatted), '%F', Date).

% ISO date for microdata.

:- st_set_function(iso_date, 1, iso_date).

iso_date(Ts, Date):-
    format_time(atom(Date), '%F', Ts).

% Overrides standard comment to include
% email and site.

:- register_schema(bc_comment, _{
    type: dict,
    tag: comment,
    keys: _{
        author: _{ type: string, min_length: 1 },
        content: _{ type: string, min_length: 1 },
        question: integer,
        answer: atom,
        email: string,
        site: string
    }
}).
