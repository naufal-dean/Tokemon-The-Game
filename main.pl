:- dynamic(gameStarted/1).

:- include(initgame).
:- include(util).
:- include(map).

% init game
:- initialization(nl).
:- initialization(write('Type "start." to start the game!')).
:- initialization(nl).

gameStarted(no).

start :-
    gameStarted(yes),
    ongoingGameMsg,
    !.

start :-
    gameStarted(no),
    retract(gameStarted(no)),
    asserta(gameStarted(yes)),
    write('Game started!'), nl,
    welcomeMsg,
    help,
    repeat,
    read(Input),
    do(Input),
    Input = quit.

quit :-
    gameStarted(no),
    notStartedMsg,
    !.

quit :-
    gameStarted(yes),
    retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    write('Quitting game..'), nl,
    !.
