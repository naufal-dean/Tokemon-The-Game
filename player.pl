playerName(_) :- checkStart, !.
playerName('Ahadi').

initPlayer :- checkStart, !.
initPlayer :-
	repeat,
		write('Enter your name: '),
		read(Name),
		(	validName(Name) -> (
				retract(playerName(_)),
				asserta(playerName(Name)),
				format('Woww, nice name! \nWelcome ~a to this wonderful World of Tokemon!...', [Name]), nl, nl
			)
		),
		!.
validName(_) :- checkStart, !, fail.
validName(Name) :- checkValidInput(Name), !, fail.
validName(_).

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