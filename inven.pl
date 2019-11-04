searchInven(_,_) :- checkStart, !.
searchInven([X|_], X).
searchInven([_|T], X) :- searchInven(T, X).

delTokemon(_,_,_) :- checkStart, !.
delTokemon([X|T], X, T).
delTokemon([H|T], X, L) :-
	delTokemon(T, X, [H|L]).

showInven(_) :- checkStart, !.
showInven([]) :-
	nl.
showInven([Name|T]) :-
	getHP(Name, HP),
	getType(Name, Type),
	format('~w\nHealth: ~w\nType: ~w\n\n', [Name, HP, Type]),
	showInven(T).

fullInven :- checkStart, !.
fullInven :-
	myToke(MyToke),
	countToke(MyToke, 6).

countToke(_,_) :- checkStart, !.
countToke([], 0).
countToke([_|T], N) :-
	countToke(T, N2),
	N is N2+1.
