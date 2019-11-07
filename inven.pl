searchInven(_,_) :- checkStart, !.
searchInven([X|_], X).
searchInven([_|T], X) :- searchInven(T, X).

insertInven([], Y, [Y]) :- !.
insertInven([X|Xs], Y, Z) :-
	insertInven(Xs, Y, Z2),
	Z = [X|Z2].

delTokemon(_) :- checkStart, !.
delTokemon(Nick) :-
	myToke(MyToke),
	delTokemonUtil(MyToke, Nick, NewToke),
	retract(myToke(_)),
	asserta(myToke(NewToke)).

delTokemonUtil(_,_,_) :- checkStart, !.
delTokemonUtil([X|T], X, T).
delTokemonUtil([H|T], X, L) :-
	delTokemonUtil(T, X, [H|L]).

drop(_) :- checkStart, !.
drop(_) :-
	countToke(1),
	write('You only have one tokemon, please do not drop him/her :('), nl,
	!.
drop(Nick) :-
	delTokemon(Nick),
	write('You have dropped '), write(Nick), nl,
	!.
drop(_) :-
	noTokemonMsg.

addTokemon(_,_) :- checkStart, !.
addTokemon(Nick, Name) :-
	tokeData(Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level),
	asserta(tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level)),
	myToke(MyToke),
	insertInven(MyToke, Nick, NewToke),
	retract(myToke(_)),
	asserta(myToke(NewToke)),
	!.

showInven(_) :- checkStart, !.
showInven([]) :-
	nl.
showInven([Nick|T]) :-
	getHP(Nick, HP),
	getType(Nick, Type),
	format('~w\nHealth: ~w\nType: ~w\n\n', [Nick, HP, Type]),
	showInven(T).

fullInven :- checkStart, !.
fullInven :-
	myToke(MyToke),
	countToke(MyToke, 6).

countToke(_) :- checkStart, !.
countToke(N) :-
	myToke(MyToke),
	countFromList(MyToke, N).

countEnemy(_) :- checkStart, !.
countEnemy(N) :-
	enemy(Enemy),
	countFromList(Enemy, N).

countFromList(_,_) :- checkStart, !.
countFromList([], 0).
countFromList([_|T], N) :-
	countFromList(T, N2),
	N is N2+1.