map :- checkStart, !.
map :- showMap(0, 0), nl.

showMap(_,_) :- checkStart, !.
showMap(R, C) :-
	nextRCMap(R, C, RNext, CNext),
	at(Item, R, C),
	showOneTile(Item),
	mapSize(_, Col),
	ColNext is Col + 1,
	(C is ColNext -> nl;write(' ')),
	showMap(RNext, CNext).
showMap(_,_).

showOneTile(_) 		:- checkStart, !.
showOneTile(fence) 	:- write('X').
showOneTile(player) :- write('P').
showOneTile(gym) 	:- write('G').
showOneTile(water) 	:- write(' ').
showOneTile(dirt) 	:- write('-').
showOneTile(forest) :- write('"').
showOneTile(grass) 	:- write(',').
showOneTile(cave) 	:- write('o').
