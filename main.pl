:- module(main, []).

/** <module> The main module */

:- use_module(library(bc/bc_main)).
:- use_module(lib/routes).
:- use_module(lib/config).

% Initializes the serving daemon.

:- config(db, File), bc_main(File).
