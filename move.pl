% valid map 1,1 ... mapSize(Row,Col)
% (1,1) is on upper left
n :- movePlayer(-1, 0).
e :- movePlayer(0, 1).
w :- movePlayer(0, -1).
s :- movePlayer(1, 0).

movePlayer(_,_) :- checkStart, !.
movePlayer(DeltaR, DeltaC) :-
	at(player, R, C),
	RNew is R+DeltaR,
	CNew is C+DeltaC,
	moveTo(RNew, CNew).

moveTo(_,_) :- checkStart, !.
moveTo(RDest, CDest) :-
	mapSize(Row, Col),
	(RDest < 1 ; RDest > Row ; CDest < 1; CDest > Col; at(pagar, RDest, CDest)),
	invalidMoveMsg,
	!.
moveTo(RDest, CDest) :-
	retract(at(player, R, C)),
	asserta(at(player, RDest, CDest)),
	DeltaR is RDest-R,
	DeltaC is CDest-C,
	moveMsg(DeltaR, DeltaC).
