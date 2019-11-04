:- dynamic(playerName/1, tokemonCount/1, playerPos/2, inven/1).

/* Fakta */
/* Player */
/* Format: player(nama,jumlah_tokemon,pos_x,pos_y) */
/* max jumlah_tokemon = 6 */
playerName(_).
tokemonCount(1).

/* Inventory Tokemon */
/* Format: inventory(nama_tokemon,current_hp,current_exp,current_level,skill_status) */

/* Rules */
initPlayer :- checkStart, !.
initPlayer :-
	write('Enter your name: '),
	read(Name),
	retract(playerName(_)),
	asserta(playerName(Name)),
	format('Woww, nama yang bagus..\nSelamat datang ~a, di dunia Tokemon yang indah ini...\n\n', [Name]).

showInven(_) :- checkStart, !.
showInven([]) :-
	nl.
showInven([H|T]) :-
	tokemon(H, HP, Type, _, _, _, _, _),
	format('~w\nHealth: ~w\nType: ~w\n\n', [H, HP, Type]),
	showInven(T).

showMyTokes :-
	myToke(MyToke),
	showInven(MyToke).

showEnemies :-
	enemy(Enemy),
	showInven(Enemy).

status :- checkStart, !.
status :-
	write('Your Tokemon:'), nl, showMyTokes,
	write('Your Enemy:'), nl, showEnemies.

checkCond :- checkStart, !.
checkCond :-
	myToke(MyToke),
	isEmpty(MyToke, true),
	lose.
checkCond :-
	enemy(Enemy),
	isEmpty(Enemy, true),
	win.

lose :- checkStart, !.
lose :-
	write('You died!'), nl,
	quit, abort,
	!.

win :- checkStart, !.
win :-
	write('You won!'), nl,
	quit, abort,
	!.