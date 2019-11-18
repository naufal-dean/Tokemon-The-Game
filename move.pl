% valid map 1,1 ... mapSize(Row,Col)
% (1,1) is on upper left
n :- movePlayer(-1, 0).
e :- movePlayer(0, 1).
w :- movePlayer(0, -1).
s :- movePlayer(1, 0).

moves(0).

movePlayer(_,_) :- checkStart, !.
movePlayer(_,_) :-
	battleStarted(yes),
	enemyToke(_,HP,_,_,_,_,_,_,_),
	HP > 0,
	checkBattle(yes),
	write('Type "run." to exit the battle'), nl,
	!.
movePlayer(DeltaR, DeltaC) :-
	battleStarted(yes),
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,

	activeToke(Toke,_),
	killXP(Enemy,PlusExp),
	retract(tokemon(Toke,Name,HP,Type,Att,Skill,SkillDmg,Exp,Level)),
	NewExp is Exp + PlusExp,
	asserta(tokemon(Toke,Name,HP,Type,Att,Skill,SkillDmg,NewExp,Level)),
	format('~a gained ~w exp...', [Toke,PlusExp]), nl,
	levelUp(Toke), nl,

	endBattle,
	write('You left the battlefield...'), nl,
	movePlayer(DeltaR, DeltaC),
	!.
movePlayer(DeltaR, DeltaC) :-
	at(player, R, C),
	RNew is R+DeltaR,
	CNew is C+DeltaC,
	moveTo(RNew, CNew).

moveTo(_,_) :- checkStart, !.
moveTo(RDest, CDest) :-
	mapSize(Row, Col),
	(
		RDest < 1 ;
		RDest > Row;
		CDest < 1;
		CDest > Col;
		at(fence, RDest, CDest);
		at(water, RDest, CDest)
	),
	invalidMoveMsg,
	!.
moveTo(RDest, CDest) :-
	map,
	retract(at(player, R, C)),
	((
		at(Terrain1, R, C),
		at(Terrain2, RDest, CDest),
		Terrain1 \== Terrain2
	) -> (
		write('Arrived at '), write(Terrain2), nl
	) ; (
		DeltaR is RDest-R,
		DeltaC is CDest-C,
		moveMsg(DeltaR, DeltaC)
	)),
	asserta(at(player, RDest, CDest)),
	retract(moves(MoveCnt)),
	MoveCntPlus is MoveCnt+1,
	asserta(moves(MoveCntPlus)),
	calcChance(Chance),
	triggerEnemy(Chance).

% Chance = random(Base+MoveCnt+(TokeCnt*10))
calcChance(_) :- checkStart, !.
calcChance(Chance) :-
	Base is 1001,
	moves(MoveCnt),
	countToke(TokeCnt),
	ChanceCap is Base + MoveCnt//10 + TokeCnt*10,
	random(1, ChanceCap, Chance).

% Chance : random (1-1000) + (10-60) + 1-..(500?)
% Base : 90% no enemy, 9% normal, 1% legend
% 100 moves & 2 toke : +- 1%
% 1000 moves & 6 toke : +- 15%
triggerEnemy(_) :- checkStart, !.
triggerEnemy(Chance) :-
	Chance < 900,
	!.
triggerEnemy(Chance) :-
	Chance < 990,

	getLandType(LandType),
	enemiesOn(LandType, Enemies),
	countFromList(Enemies, NBElements),

	random(0, NBElements, X), Idx is X-1,
	nth(Idx, Enemies, Encounter),
	initBattle(Encounter),
	!.
triggerEnemy(_) :-
	enemy(Enemy),
	countEnemy(LegendCnt),
	random(0, LegendCnt, X),
	Idx is X+1,
	nth(Idx, Enemy, Encounter),
	initBattle(Encounter).

% if on water, return water-type pokemons... etc
enemiesOn(_,_) :- checkStart, !.
enemiesOn(water, Enemies) :-
	waterEnemies(Enemies),
	!.
enemiesOn(grass, Enemies) :-
	grassEnemies(Enemies),
	!.
enemiesOn(cave, Enemies) :-
	caveEnemies(Enemies),
	!.
enemiesOn(forest, Enemies) :-
	forestEnemies(Enemies),
	!.
enemiesOn(dirt, Enemies) :-
	dirtEnemies(Enemies),
	!.

getLandType(_) :- checkStart, !.
getLandType(LandType) :-
	at(player, R, C),
	at(LandType, R, C),
	LandType \== player.
getLandType(dirt).
