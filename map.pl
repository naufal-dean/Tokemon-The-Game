map :- checkStart, !.
map :-
	showMap(0, 0),
	nl.

% kanan bawah, basis
showMap(_,_) :- checkStart, !.
showMap(R, C) :-
	mapSize(Row, Col),
	C > Col,
	R > Row,
	showOneTile(fence),
	!.
% tembok kanan
showMap(R, C) :-
	mapSize(_, Col),
	C > Col,
	RNext is R+1,
	showOneTile(fence), showOneTile(space), nl,
	!,
	showMap(RNext, 0).
% tembok atas, bukan plg kanan
showMap(0, C) :-
	showOneTile(fence), showOneTile(fence),
	CNext is C+1,
	!,
	showMap(0, CNext).
% tembok bawah, bukan plg kanan
showMap(R, C) :-
	mapSize(Row, _),
	R > Row,
	showOneTile(fence), showOneTile(fence),
	CNext is C+1,
	!,
	showMap(R, CNext).
% tembok kiri, bukan plg atas atau bawah
showMap(R, 0) :-
	showOneTile(fence), showOneTile(space),
	!,
	showMap(R, 1).

% isi map
showMap(R, C) :-
	at(Item, R, C),
	showOneTile(Item), showOneTile(space),
	CNext is C+1,
	!,
	showMap(R, CNext).
showMap(R, C) :-
	showOneTile(dirt), showOneTile(space),
	CNext is C+1,
	!,
	showMap(R, CNext).


showOneTile(_) :- checkStart, !.
showOneTile(fence) :-
	write('X').
showOneTile(player) :-
	write('P').
showOneTile(gym) :-
	write('G').
showOneTile(water) :-
	write('~').
showOneTile(dirt) :-
	write('-').
showOneTile(grass) :-
	write('v').
showOneTile(space) :-
	write(' ').