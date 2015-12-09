:- module(main, []).

/** <module> The main module */

:- use_module(library(bc/bc_env)).

% Catch uncaught errors/warnings and shut down
% when they occur.

:- dynamic(loading/1).
:- asserta(loading(0)).

% The first hook is for detecting
% loading state.

user:message_hook(Term, _, _):-
    (   Term = load_file(start(Level, _))
    ->  asserta(loading(Level))
    ;   (   Term = load_file(done(Level, _, _, _, _, _))
        ->  retractall(loading(Level))
        ;   true)),
    fail.

% The second hook shuts down SWI when
% error occurs during loading.

:- if(bc_env_production).
    user:message_hook(Term, Type, _):-
        loading(_),
        ( Type = error ; Type = warning ),
        message_to_string(Term, String),
        writeln(user_error, String),
        halt(1).
:- endif.

:- use_module(library(bc/bc_main)).
:- use_module(library(bc/bc_type)).
:- use_module(lib/routes).
:- use_module(lib/config).

% Enables preview for posts.

:- bc_register_preview(post, '/post/<slug>').

% Initializes the serving daemon.

:- config(db, File), bc_main(File).
