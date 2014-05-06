:- module(sitemap, [
    send_sitemap/0
]).

/** <module> The XML sitemap handler */

:- use_module(library(docstore)).
:- use_module(library(bc/bc_view)).
:- use_module(config).

%! send_sitemap is det.
%
% Sends the sitemap response.
% Sitemap contains links to all posts
% and tag pages.

send_sitemap:-
    ds_find(entry, (type=post, published=true), Posts),
    sitemap_tags(Posts, Tags),
    config(site, Site),
    bc_view_send(views/sitemap, _{
        posts: Posts,
        tags: Tags,
        site: Site
    }, 'Content-type: application/xml; charset=UTF-8').

%! sitemap_tags(+Posts, -Tags) is det.
%
% Takes the list of posts and gives
% the sorted list of unique tags that
% are used for the given posts.

sitemap_tags(Posts, Tags):-
    sitemap_tags(Posts, [], List),
    sort(List, Tags).

sitemap_tags([Post|Posts], Acc, List):-
    Tags = Post.tags,
    append(Tags, Acc, Next),
    sitemap_tags(Posts, Next, List).

sitemap_tags([], List, List).
