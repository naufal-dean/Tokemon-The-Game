:- dynamic(gameStarted/1).

:- include(util).

% daftar command yang valid
command(start).
command(quit).

% init game
:- initialization(nl).
:- initialization(write('Type "start." to start the game!')).
:- initialization(nl).

gameStarted(no).

start :-
	gameStarted(yes),
	write('Ongoing game detected, type "quit." to restart current game.'), nl,
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
	write('No ongoing game detected. type "start." to start the game.'), nl,
	!.

quit :-
	gameStarted(yes),
	retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    write('Quitting game..'), nl,
    !.
