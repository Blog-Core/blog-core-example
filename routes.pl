:- module(routes, []).

/** <module> The application routes */

:- use_module(library(arouter)).
:- use_module(sitemap).
:- use_module(feed).
:- use_module(post).
:- use_module(front).

% Page for single post.

:- route_get(post/Slug, send_post(Slug)).

% Similar for a page. Reuses post logics.

:- route_get(page/Slug, send_post(Slug)).

% Page with the list of all posts.

:- route_get(posts, send_all_posts).

% Page with posts related to the tag.

:- route_get(tag/Tag, send_tag(Tag)).

% The front page.

:- route_get(/, send_front).

% The XML sitemap.

:- route_get('sitemap.xml', send_sitemap).

% The Atom newsfeed.

:- route_get(atom, send_feed).
