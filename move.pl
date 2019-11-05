% valid map 1,1 ... mapSize(Row,Col)
% (1,1) is on upper left
n :- movePlayer(-1, 0).
e :- movePlayer(0, 1).
w :- movePlayer(0, -1).
s :- movePlayer(1, 0).

moves(0).

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
	moveMsg(DeltaR, DeltaC),

	retract(moves(MoveCnt)),
	MoveCntPlus is MoveCnt+1,
	asserta(moves(MoveCntPlus)),
	
	calcChance(Chance),
	triggerEnemy(Chance).

% Chance = random(Base+MoveCnt+(TokeCnt*10))
calcChance(_) :- checkStart, !.
calcChance(Chance) :-
	Base is 1001,
	moves(MoveCnt//10),
	countToke(TokeCnt),
	ChanceCap is Base + MoveCnt + TokeCnt*10,
	random(1, ChanceCap, Chance).

% Chance : random (1-1000) + (10-60) + 1-..(500?)
% Base : 80% no enemy, 15% normal, 5% legend
% 100 moves & 2 toke : +- 1%
% 1000 moves & 6 toke : +- 15%
triggerEnemy(_) :- checkStart, !.
triggerEnemy(Chance) :-
	Chance < 800.
triggerEnemy(Chance) :-
	Chance < 950,
	random(1, 6, X),
	switch(X, [
		1: Enemy is 'Insectmon',
		2: Enemy is 'Waterlemon',
		3: Enemy is 'Chillmon',
		4: Enemy is 'Phillipmon',
		5: Enemy is 'Gelapmon'
	]),
	initBattle(Enemy).
