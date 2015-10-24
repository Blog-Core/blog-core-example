:- module(feed, [
    send_feed/0
]).

/** <module> The Atom feed handler */

:- use_module(library(docstore)).
:- use_module(library(st/st_expr)).
:- use_module(library(list_util)).
:- use_module(library(sort_dict)).
:- use_module(library(bc/bc_view)).
:- use_module(config).

%! send_feed is det.
%
% Sends the atom feed response.
% Includes all published posts.
% Uses last 25 posts by publish date.

send_feed:-
    ds_find(entry, (type=post, published=true), Posts),
    sort_dict(date_published, desc, Posts, Sorted),
    take(25, Sorted, Recent),
    feed_update_date(Recent, Date),
    config(site, Site),
    config(title, Title),
    bc_view_send(views/feed, _{
        updated: Date,
        entries: Recent,
        site: Site,
        title: Title
    }, 'Content-type: application/atom+xml; charset=UTF-8').

% Function to get author in feed.

:- st_set_function(feed_author, 1, feed_author).

feed_author(Id, Fullname):-
    ds_col_get(user, Id, [fullname], User),
    Fullname = User.fullname.

% Function to format date in feed.
% Dates in the Atom feeds are full
% ISO8601 dates.

:- st_set_function(feed_date, 1, feed_date).

feed_date(Ts, Date):-
    format_time(atom(Date), '%FT%T%:z', Ts).

% Update date from posts. Gives
% the current time when the list is empty.

feed_update_date(Posts, Date):-
    (   Posts = []
    ->  get_time(Date)
    ;   Posts = [Post|_],
        Date = Post.date_published).
