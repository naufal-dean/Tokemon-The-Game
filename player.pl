playerName(_) :- checkStart, !.
playerName('Ahadi').

initPlayer :- checkStart, !.
initPlayer :-
	write('Enter your name: '),
	read(Name),
	retract(playerName(_)),
	asserta(playerName(Name)),
	format('Woww, nama yang bagus..\nSelamat datang ~a, di dunia Tokemon yang indah ini...', [Name]), nl, nl,
	!.

status :- checkStart, !.
status :-
	write('Your Tokemon:'), nl, showMyTokes,
	write('Your Enemy:'), nl, showEnemies,
	!.

checkCond :- checkStart, !.
checkCond :-
	myToke(MyToke),
	isEmpty(MyToke, true),
	lose,
	!.
checkCond :-
	enemy(Enemy),
	isEmpty(Enemy, true),
	win,
	!.

lose :- checkStart, !.
lose :- loseMsg, quit, abort, !.

win :- checkStart, !.
win :- winMsg, quit, abort, !.