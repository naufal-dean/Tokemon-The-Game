playerName(_) :- checkStart, !.

initPlayer :- checkStart, !.
initPlayer :-
	repeat,
		write('Enter your name: '),
		read(Name),
		(	(isValid(Name, X), X == valid) -> (
				!,
				retractall(playerName(_)),
				asserta(playerName(Name)),
				format('Woww, nice name! \nWelcome ~a to this wonderful World of Tokemon!...', [Name]), nl, nl
			)
		).

isValid(_,_) :- checkStart, !.
isValid(Name, invalid) :- Name == end_of_file, !.
isValid(Name,invalid) :- checkInvalidInput(Name), !.
isValid(_, valid).

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