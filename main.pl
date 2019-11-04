:- dynamic(gameStarted/1, at/3).

:- include(initgame).
:- include(util).
:- include(map).
:- include(move).
:- include(player).
:- include(tokemon).

% init game
:- initialization(startGameMsg).

gameStarted(no).

start :-
    retract(gameStarted(no)),
    asserta(gameStarted(yes)),
    welcomeMsg,
    initPlayer,
    help,
    repeat,
        write('>>> '),
        read(Input),
        do(Input),
        checkCond,
    Input = quit.

quit :- checkStart, !.
quit :-
    retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    write('Quitting game..'), nl,
    !.