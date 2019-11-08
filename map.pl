map :- checkStart, !.
map :- showMap(1, 1), nl.

showMap(_,_) :- checkStart, !.
showMap(R, C) :-
	nextRC(R, C, RNext, CNext),
	at(Item, R, C),
	showOneTile(Item),
	mapSize(_, Col),
	(C =:= Col -> nl;write(' ')),
	showMap(RNext, CNext).
showMap(_,_).

showOneTile(_) 		:- checkStart, !.
showOneTile(fence) 	:- write('X').
showOneTile(player) :- write('P').
showOneTile(gym) 	:- write('G').
showOneTile(water) 	:- write('~').
showOneTile(dirt) 	:- write('-').
showOneTile(forest) :- write('"').
showOneTile(grass) 	:- write(',').
showOneTile(cave) 	:- write('o').
