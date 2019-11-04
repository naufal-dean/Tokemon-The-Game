:- dynamic(playerName/1, tokemonCount/1, playerPos/2, inventory/5).

:- include(tokemon).
:- include(util).

/* Fakta */
/* Player */
/* Format: player(nama,jumlah_tokemon,pos_x,pos_y) */
/* max jumlah_tokemon = 6 */
playerName(name).
tokemonCount(1).
playerPos(X,Y).

/* Inventory Tokemon */
/* Format: inventory(nama_tokemon,current_hp,current_exp,current_level,skill_status) */

/* Rules */
% initPlayer :-
%   readFile('data/newGame.txt'),
%   write('Masukkan nama kamu: '),
%   read(Name), nl,
%     retract(playerName(name)),
%     asserta(playerName(Name)),
%   write('Woww, nama yang bagus..~nSelamat datang ~a, di dunia Tokemon yang indah ini...~n', [Name]).
