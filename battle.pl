capture :-
	at(player, R, C),
	at(Toke, R, C),
	Toke \== gym,
	getHP(Toke, HP),
	HP =:= 0,
	write(Toke), write(' is captured!'), nl.