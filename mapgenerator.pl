% ======================================== Generator ======================================== 
%%% generateMap/1
% menghasilkan 1 sumber dirt di tengah,
% dan beberapa sumber terrain lain (random with chance - lihat plg bawah)
% di titik random (dengan syarat tidak boleh bersebelahan - lihat noPointsAround/2)
%%%
generateMap :- checkStart, !.
generateMap :-
	mapSize(Row, Col),
	R is Row//2, C is Col//2,
	asserta(point(dirt, R, C)),
	asserta(at(dirt, R, C)),
	NumPoint is floor(Row/10*Col/10),
	NumWater is NumPoint,
	generateWater(NumWater),
	generateTerrain(NumPoint),
	placeTerrain,
	placeBuildings,
	placeBorder,
	!.

generateWater(_) :- checkStart, !.
generateWater(0).
generateWater(N) :-
	generatePoint(water),
	NMin is N-1,
	!,
	generateWater(NMin).

%%% generateTerrain/1
% menghasilkan N sumber terrain random
%%%
generateTerrain(_) :- checkStart, !.
generateTerrain(0).
generateTerrain(N) :-
	random(0, 100, X),
	terrainIs(X, Terrain),
	generatePoint(Terrain),
	NMin is N - 1,
	!,
	generateTerrain(NMin).

%%% generatePoint/1
% menghasilkan sebuah sumber terrain di tempat random
%%%
generatePoint(_) :- checkStart, !.
generatePoint(Terrain) :-
	mapSize(Row, Col),
	RowPlus is Row+1, ColPlus is Col+1,
	repeat,
		random(1, RowPlus, R),
		random(1, ColPlus, C),
		(	validPoint(Terrain, R, C)
		->	!,
			asserta(point(Terrain, R, C))
		).

%%% generateFence/1
% menghasilkan N garis fence
%%%
generateFence(_) :- checkStart, !.
generateFence(0).
generateFence(N) :-
	mapSize(Row, Col),
	random(1, Row, RDest),
	random(1, Col, CDest),
	Row2 is Row-1, Col2 is Col-1,
	repeat,
		random(1, Row2, RDest2),
		random(1, Col2, CDest2),
		(	validFencePos(RDest, CDest, RDest2, CDest2) -> (
				!,
				placeFence(RDest, CDest, RDest2, CDest2),
				NMin is N-1,
				generateFence(NMin)
			)
		).

%%% generateGym/1
% menghasilkan N gym tidak berdekatan (jarak >= X)
%%%
generateGym(_) :- checkStart, !.
generateGym(0).
generateGym(N) :-
	mapSize(Row, Col),
	R is Row-2, C is Col-2,
	repeat,
		random(3, R, RDest),
		random(3, C, CDest),
		(	validGymPos(RDest, CDest) -> (
				!,
				retract(at(_, RDest, CDest)),
				asserta(at(gym, RDest, CDest)),
				NMin is N-1,
				!,
				generateGym(NMin)
			)
		).

placeTerrain :- checkStart, !.
placeTerrain :-
	placeTerrainUtil(1,1),
	!.

placeTerrainUtil(_,_) :- checkStart, !.
placeTerrainUtil(R, C) :-
	nextRC(R, C, RNext, CNext),
	closestPointFrom(R, C, Terrain, _, _),
	asserta(at(Terrain, R, C)),
	placeTerrainUtil(RNext, CNext).
placeTerrainUtil(_,_).

placeBuildings :- checkStart, !.
placeBuildings :-
	mapSize(Row, Col),
	R is Row//2, C is Col//2,
	retract(at(_, R, C)),
	asserta(at(player, R, C)),
	NumFence is floor(Row/20*Col/20)+1,
	generateFence(NumFence),
	NumGym is floor(Row/16*Col/16)+1,
	generateGym(NumGym),
	!.

% !!!!!!!!!!!!!! ini diubah ya !!!!!!!!!
% harusnya bentuk garis dari (R1, C1) ke (R2, C2)
placeFence(_,_,_,_) :- checkStart, !.
placeFence(R1, C1, R2, C2) :-
	retract(at(_, R1, C1)),
	retract(at(_, R2, C2)),
	asserta(at(fence, R1, C1)),
	asserta(at(fence, R2, C2)).

placeBorder :- checkStart, !.
placeBorder :-
	placeBorderUtil(0,0),
	!.

placeBorderUtil(_,_) :- checkStart, !.
placeBorderUtil(RNext, CNext) :-
	mapSize(Row, Col),
	RNext is Row + 1,
	CNext is Col + 1,
	asserta(at(fence, RNext, CNext)),
	!.
placeBorderUtil(R,CNext) :-
	mapSize(_, Col),
	CNext is Col+1,
	RNext is R+1,
	asserta(at(fence, R, CNext)),
	!,
	placeBorderUtil(RNext, 0).
placeBorderUtil(0,C) :-
	CNext is C + 1,
	asserta(at(fence, 0, C)),
	!,
	placeBorderUtil(0, CNext).
placeBorderUtil(RNext,C) :-
	mapSize(Row, _),
	RNext is Row + 1,
	CNext is C + 1,
	asserta(at(fence, RNext, C)),
	!,
	placeBorderUtil(RNext, CNext).
placeBorderUtil(R, 0) :-
	mapSize(_, Col),
	CNext is Col + 1,
	asserta(at(fence, R, 0)),
	!,
	placeBorderUtil(R, CNext).