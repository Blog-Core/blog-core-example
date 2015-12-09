:- module(front, [
    send_front/0
]).

/** <module> Handles the front page */

:- use_module(library(docstore)).
:- use_module(library(sort_dict)).
:- use_module(library(bc/bc_view)).

:- use_module(config).
:- use_module(take_prefix).

%! send_front is det.
%
% Sends the front page. Uses special post
% with slug `about` for the welcoming text
% and the page description.

send_front:-
    recent_posts(Recent),
    ds_find(entry, slug=about, [About]),
    config(title, Title),
    bc_view_send(views/front, _{
        posts: Recent,
        about: About,
        title: Title,
        description: About.description
    }).

%! recent_posts(-Recent) is det.
%
% Finds the last 10 published posts.

recent_posts(Recent):-
    ds_find(entry, (type=post, published=true), Posts),
    sort_dict(date_published, desc, Posts, Sorted),
    take_prefix(10, Sorted, Recent).
