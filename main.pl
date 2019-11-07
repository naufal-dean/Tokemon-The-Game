:- dynamic(gameStarted/1, at/3, enemy/1, myToke/1, playerName/1, moves/1).
:- dynamic(battleStarted/1, encounter/1, activeToke/2, enemyToke/9, tokemon/9).
:- dynamic(healUsed/1).

:- include(initgame).
:- include(config).
:- include(util).
:- include(map).
:- include(move).
:- include(player).
:- include(tokemon).
:- include(inven).
:- include(battle).
:- include(battleutil).
:- include(gym).

% init game
:- initialization(startGameMsg).

gameStarted(no).

start :-
    retract(gameStarted(no)),
    asserta(gameStarted(yes)),
    randomize,
    welcomeMsg,
    initPlayer,
    help, nl,
    map, nl,
    repeat,
        write('>>> '),
        read(Input),
        (   do(Input) -> true
        ;   (!, fail)
        ),
        checkCond.

quit :- checkStart, !.
quit :-
    quitGameMsg,
    retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    reloadGame('initgame.pl').
