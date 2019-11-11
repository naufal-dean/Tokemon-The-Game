% ======================= Map Iterator =======================
nextRC(_,_,_,_) :- checkStart, !.
nextRC(RNext, _, _, _) :-
	mapSize(Row, _),
	RNext is Row +1,
	!, fail.
nextRC(R, Col, RNext,1) :-
	mapSize(_, Col),
	RNext is R+1,
	!.
nextRC(R, C, R, CNext) :-
	CNext is C+1,
	!.

% ==================== Calculate Distances ====================
dist(_,_,_,_,_) :- checkStart, !.
dist(R, C, R2, C2, Dist) :-
	Dist is ((R2-R)**2+(C2-C)**2)**0.5.

closestBuildingFrom(_,_,_,_,_,_) :- checkStart, !.
closestBuildingFrom(R, C, Building, RB, CB, Building2) :-
	at(Building, RB, CB),
	dist(R, C, RB, CB, Dist),
	\+ (
		at(Building2, RB2, CB2),
		dist(R, C, RB2, CB2, Dist2),
		Dist2 < Dist
	),
	!.

closestPointFrom(_,_,_,_,_) :- checkStart, !.
closestPointFrom(R, C, Terrain, RT, CT) :-
	point(Terrain, RT, CT),
	dist(R, C, RT, CT, Dist),
	\+ (
		point(Terrain2, RT2, CT2),
		Terrain2 \== Terrain,
		dist(R, C, RT2, CT2, Dist2),
		Dist2 < Dist
	),
	!.

% =================== Validasi Map Generator ===================
noPointAround(_,_) :- checkStart, !.
noPointAround(R, C)	:-
	(
		point(_, R-1, C-1);
		point(_, R-1, C);
		point(_, R-1, C+1);
		point(_, R, C-1);
		point(_, R, C);
		point(_, R, C+1);
		point(_, R+1, C-1);
		point(_, R+1, C);
		point(_, R+1, C+1)
	),
	!, fail.
noPointAround(_, _).

validGymPos(_,_) :- checkStart, !.
validGymPos(R, C) :-
	(
		at(water, R, C);
		at(cave, R, C);
		at(player, R, C);
		(
			closestBuildingFrom(R, C, gym, RB, CB, gym),
			dist(R, C, RB, CB, Dist),
			mapSize(Row, Col),
			Dist < (Row+Col)/10
		)
	), !, false.
validGymPos(_,_).

validFencePos(_,_,_,_) :- checkStart, !.
validFencePos(R1, C1, R2, C2) :-
	(
		(R1 is R2, C1 is C2);
		(
			at(player, RP, CP),
			(R1 is RP; R2 is RP; C1 is CP; C2 is CP)
		)
	),
	!, false.
validFencePos(_,_,_,_).

% =========================== Terrain Chance ===========================
% cave  : 10%
% water : 15%
% dirt  : 15%
% forest: 25%
% grass : 35%
terrainIs(_,_) :- checkStart, !.
terrainIs(X, cave)   :- X < 10, !.
terrainIs(X, water)  :- X < 25, !.
terrainIs(X, dirt)   :- X < 40, !.
terrainIs(X, forest) :- X < 65, !.
terrainIs(X, grass)  :- X < 100, !.