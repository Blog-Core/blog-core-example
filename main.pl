:- module(main, []).

/** <module> The main module */

:- use_module(library(bc/bc_env)).

:- dynamic(started/0).

% Catch uncaught errors/warnings before start and shut down
% when they occur.

user:message_hook(Term, Type, _):-
    \+ started,
    ( Type = error ; Type = warning ),
    message_to_string(Term, String),
    writeln(user_error, String),
    halt(1).

:- use_module(library(bc/bc_main)).
:- use_module(library(bc/bc_type)).
:- use_module(lib/routes).
:- use_module(lib/config).
:- use_module(library(bc/bc_router)).
:- use_module(library(bc/bc_data)).
:- use_module(library(http/http_unix_daemon)).
:- use_module(library(http/thread_httpd)).

% Enables preview for posts.

:- bc_register_preview(post, '/post/<slug>').

% Initialize the serving daemon.

http_unix_daemon:http_server_hook(Options):-
    http_server(bc_route, Options),
    assertz(started).

start:-
    started, !.

start:-
    config(db, File),
    bc_data_open(File),
    http_daemon.

:- start.
