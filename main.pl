:- module(main, []).

/** <module> The main module */

:- use_module(library(bc/bc_main)).
:- use_module(library(bc/bc_type)).
:- use_module(lib/routes).
:- use_module(lib/config).

% Enables preview for posts.

:- bc_register_preview(post, '/post/<slug>').

% Initializes the serving daemon.

:- config(db, File), bc_main(File).
