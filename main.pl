% ======================= TOKEMON GAME - Kelas 3 Kelompok 5 =======================
% dibuat untuk menyelesaikan tugas kuliah logika komputasional, oleh:
%   - Jonathan Yudi Gunawan / 13518084
%   - 
%   - 
%   - 
%
% ================================================================================

% =============================== Dynamic Variables ===============================
:- dynamic(gameStarted/1, at/3, enemy/1, myToke/1, playerName/1, moves/1, point/3).
:- dynamic(battleStarted/1, encounter/1, activeToke/2, enemyToke/9, tokemon/9, healUsed/1).

% ================================= Dependencies =================================
:- include(initgame).
:- include(config).
:- include(util).
:- include(messages).
:- include(map).
:- include(maputil).
:- include(mapgenerator).
:- include(move).
:- include(player).
:- include(tokemon).
:- include(inven).
:- include(battle).
:- include(battleutil).
:- include(gym).

% =============================== Initialization ===============================
:- initialization(startGameMsg).
gameStarted(no).

% ================================== Main Loop ==================================
start :-
    retract(gameStarted(no)),
    asserta(gameStarted(yes)),
    randomize,
    welcomeMsg,
    initPlayer,
    generateMap,
    help, nl,
    map, nl,
    repeat,
        write('>>> '),
        read(Input),
        do(Input),
        checkCond.

quit :- checkStart, !.
quit :-
    quitGameMsg,
    retract(gameStarted(yes)),
    asserta(gameStarted(no)),
    reloadGame('initgame.pl').
