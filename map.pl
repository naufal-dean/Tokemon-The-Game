map :-
	gameStarted(no),
	notStartedMsg,
	!.

map :-
	showMap(0, 0),
	nl.

% kanan bawah, basis
showMap(R, C) :-
	mapSize(Row, Col),
	C > Col,
	R > Row,
	write('X'),
	!.
% tembok kanan
showMap(R, C) :-
	mapSize(_, Col),
	C > Col,
	succ(R, RNext),
	write('X'), nl,
	!,
	showMap(RNext, 0).
% tembok atas, bukan plg kanan
showMap(0, C) :-
	write('X'),
	succ(C, CNext),
	!,
	showMap(0, CNext).
% tembok bawah, bukan plg kanan
showMap(R, C) :-
	mapSize(Row, Col),
	R > Row,
	write('X'),
	succ(C, CNext),
	!,
	showMap(R, CNext).
% tembok kiri, bukan plg atas atau bawah
showMap(R, 0) :-
	write('X'),
	!,
	showMap(R, 1).

% isi map
showMap(R, C) :-
	at(Item, R, C),
	showOneTile(Item),
	succ(C, CNext),
	!,
	showMap(R, CNext).
showMap(R, C) :-
	write('.'),
	succ(C, CNext),
	!,
	showMap(R, CNext).

showOneTile(pagar) :-
	write('X').
showOneTile(player) :-
	write('P').
showOneTile(gym) :-
	write('G').