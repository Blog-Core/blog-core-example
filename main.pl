:- module(main, []).

/** <module> The main module */

:- use_module(library(bc/bc_main)).
:- use_module(routes).
:- use_module(config).

% Initializes the serving daemon.

:- config(db, File), bc_main(File).
