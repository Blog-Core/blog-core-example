:- module(routes, []).

/** <module> The application routes */

:- use_module(library(arouter)).
:- use_module(sitemap).
:- use_module(feed).

% FIXME add more specific routes last:
% https://github.com/rla/alternative-router/issues/4

% The XML sitemap.

:- route_get('sitemap.xml', send_sitemap).

% The Atom newsfeed.

:- route_get(atom, send_feed).
