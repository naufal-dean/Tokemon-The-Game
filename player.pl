playerName(_) :- checkStart, !.
playerName('Ahadi').

initPlayer :- checkStart, !.
initPlayer :-
	repeat,
		write('Enter your name: '),
		read(Name),
		(	\+ invalidName(Name) -> (
				!,
				retract(playerName(_)),
				asserta(playerName(Name)),
				format('Woww, nice name! \nWelcome ~a to this wonderful World of Tokemon!...', [Name]), nl, nl
			)
		),
		!.

invalidName(_) :- checkStart, !.
invalidName(Name) :- checkInvalidInput(Name), !.

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