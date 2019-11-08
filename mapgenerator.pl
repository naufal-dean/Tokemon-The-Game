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
	NumPoint is floor(Row/8*Col/8),
	generateTerrain(NumPoint),
	placeTerrain(1,1),
	placeBuildings,
	!.

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
		(	noPointAround(R, C)
		->	!,
			asserta(point(Terrain, R, C)),
			asserta(at(Terrain, R, C))
		;	true
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

placeTerrain(_,_) :- checkStart, !.
placeTerrain(R, C) :-
	nextRC(R, C, RNext, CNext),
	closestPointFrom(R, C, Terrain, _, _),
	asserta(at(Terrain, R, C)),
	placeTerrain(RNext, CNext).
placeTerrain(_,_).

placeBuildings :- checkStart, !.
placeBuildings :-
	mapSize(Row, Col),
	R is Row//2, C is Col//2,
	retract(at(_, R, C)),
	asserta(at(player, R, C)),
	NumFence is floor(Row/13*Col/13)+1,
	generateFence(NumFence),
	NumGym is floor(Row/9*Col/9)+1,
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
