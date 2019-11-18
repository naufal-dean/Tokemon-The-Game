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

initToke :- checkStart, !.
initToke :-
	initTokeMsg,
	repeat,
		write('Enter the Tokemon name: '),
		read(Name),
		(	(isTokeValid(Name, X1), X1 == valid) -> (
				!,
				format('Nice pick!\nYou chose ~a, it\'s a strong one...', [Name]), nl, nl
			)
		),
	write('Now please give your Tokemon a nickname...'), nl,
	repeat,
		write('Enter the Tokemon nick: '),
		read(Nick),
		(	(isValid(Nick, X2), X2 == valid) -> (
				!,
				format('Yeay... It\'s your new friend, ~a...', [Nick]), nl, nl,
				addTokemon(Nick,Name),
				write('Please be careful out there you two...'), nl,
				write('Defeat those legendary Tokemon with all your might'), nl,
				write('and restore the peace in this world...'), nl, nl
			)
		).

isValid(_,_) :- checkStart, !.
isValid(Name,invalid) :- Name == end_of_file, !.
isValid(Name,invalid) :- checkInvalidInput(Name), !.
isValid(_, valid).

isTokeValid(_,_) :- checkStart, !.
isTokeValid(Name,invalid) :- Name == end_of_file, !.
isTokeValid(Name,invalid) :- checkInvalidInput(Name), !.
isTokeValid(Name,valid) :-
	Name == insectmon,
	!.
isTokeValid(Name,valid) :-
	Name == waterlemon,
	!.
isTokeValid(Name,valid) :-
	Name == chillmon,
	!.
isTokeValid(_,invalid) :-
	write('Please choose one from these three Tokemon!'), nl,
	!.

status :- checkStart, !.
status :-
	write('===================|'), nl,
	write('   Your Tokemon:   |'), nl,
	write('-------------------|'), nl, nl,
	showMyTokes,
	write('===================|'), nl,
	write('    Your Enemy:    |'), nl,
	write('-------------------|'), nl, nl,
	showEnemies,
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
