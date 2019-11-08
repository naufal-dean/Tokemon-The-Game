initBattle(_) :- checkStart, !.
initBattle(_) :- checkBattle(yes), !.
initBattle(Enemy) :-
	retractall(battleStarted(_)),
	asserta(battleStarted(yes)),
	retractall(encounter(_)),
	asserta(encounter(yes)),
	retractall(enemyToke(_,_,_,_,_,_,_,_,_)),
	tokeData(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level),
	asserta(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,yes)),
	format('A wild Tokemon appears! It is ~a...', [Enemy]), nl,
	write('Fight or Run?'), nl,
	!.

endBattle :- checkStart, !.
endBattle :-
	retractall(battleStarted(_)),
	asserta(battleStarted(no)),
	retractall(activeToke(_,_)),
	asserta(activeToke(none,no)),
	retractall(enemyToke(_,_,_,_,_,_,_,_,_)),
	asserta(enemyToke(none,0,type,0,skill,0,0,0,no)).

checkBattle(_) :- checkStart, !.
checkBattle(no) :-
	battleStarted(no),
	notOnBattleMsg,
	!.
checkBattle(yes) :-
	battleStarted(yes),
	onBattleMsg,
	!.

checkEncounter :- checkStart, !.
checkEncounter :-
	encounter(yes),
	encounterMsg,
	!.

checkActiveToke :- checkStart, !.
checkActiveToke :-
	activeToke(none, no),
	noPickedTokeMsg,
	!.

checkDefeat :- checkStart, !.
checkDefeat :-
	enemyToke(Enemy,HP,_,_,_,_,_,_,_),
	HP =< 0,
	format('~a has been defeated!', [Enemy]), nl,
	write('Capture it or Move around to end the battle.'), nl,
	!.

enemyTurn :- checkStart, !.
enemyTurn :- checkDefeat, !.
enemyTurn :-
	write('Enemy\'s turn...'), nl,
	!.

uniqueNick(_) :- checkStart, !.
uniqueNick(Nick) :-
	myToke(MyToke),
	searchInven(MyToke, Nick),
	write('You already have a pokemon with the name '), write(Nick), nl,
	write('Please choose another name!'), nl,
	!, fail.
uniqueNick(_).