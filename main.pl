:- dynamic(gameStarted/1, at/3).

:- include(initgame).
:- include(util).
:- include(map).
:- include(move).

% init game
:- initialization(startGameMsg).

gameStarted(no).

start :-
    retract(gameStarted(no)),
    asserta(gameStarted(yes)),
    welcomeMsg,
    help,
    repeat,
        read(Input),
        do(Input),
    Input = quit.

quit :- checkStart, !.
quit :-
    retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    write('Quitting game..'), nl,
    !.