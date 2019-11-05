:- dynamic(gameStarted/1, at/3, enemy/1, myToke/1, playerName/1, moves/1).
:- dynamic(battleStarted/1, encounter/1, activeToke/2, enemyToke/9).

:- include(initgame).
:- include(util).
:- include(map).
:- include(move).
:- include(player).
:- include(tokemon).
:- include(inven).
:- include(battle).

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
    quitGameMsg,
    retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    load_internal('initgame.pl'),
    abort.
