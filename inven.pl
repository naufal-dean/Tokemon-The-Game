searchInven(_,_) :- checkStart, !.
searchInven([X|_], X).
searchInven([_|T], X) :- searchInven(T, X).

showInven(_) :- checkStart, !.
showInven([]) :-
	nl.
showInven([Nick|T]) :-
	getHP(Nick, HP),
	getType(Nick, Type),
	getLevel(Nick, Level),
	Level == 5,
	format('~w\nHealth: ~w\nType: ~w\nExp: Max\nLevel: ~w\n\n', [Nick, HP, Type, Level]),
	showInven(T),
	!.
showInven([Nick|T]) :-
	getHP(Nick, HP),
	getType(Nick, Type),
	getExp(Nick, Exp),
	getLevel(Nick, Level),
	expLimit(Level, ExpLimit),
	format('~w\nHealth: ~w\nType: ~w\nExp: ~w/~w\nLevel: ~w\n\n', [Nick, HP, Type, Exp, ExpLimit, Level]),
	showInven(T).

insertInven([], Y, [Y]) :- !.
insertInven([X|Xs], Y, Z) :-
	insertInven(Xs, Y, Z2),
	Z = [X|Z2].

addTokemon(_,_) :- checkStart, !.
addTokemon(Nick, Name) :-
	tokeData(Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level),
	asserta(tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level)),
	myToke(MyToke),
	insertInven(MyToke, Nick, NewToke),
	retract(myToke(_)),
	asserta(myToke(NewToke)),
	!.

delTokemon(_) :- checkStart, !.
delTokemon(Nick) :-
	myToke(MyToke),
	delTokemonUtil(MyToke, Nick, NewToke),
	retract(myToke(_)),
	asserta(myToke(NewToke)).

delTokemonUtil(_,_,_) :- checkStart, !.
delTokemonUtil(Old, X, New) :-
	delete(Old, X, New).

drop(_) :- checkStart, !.
drop(X) :- checkInvalidInput(X), !.
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

getMaxLvToke(_,_) :- checkStart, !.
getMaxLvToke([Toke|[]],MxLv) :-
	getLevel(Toke,MxLv),
	!.
getMaxLvToke([Toke|MyToke],MxLv) :-
	getLevel(Toke,Level1),
	getMaxLvToke(MyToke,Level2),
	Level1 > Level2,
	MxLv is Level1,
	!.
getMaxLvToke([_|MyToke],MxLv) :-
	getMaxLvToke(MyToke,MxLv),
	!.
