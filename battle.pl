battleStarted(no).
encounter(no).

% format: activeToke(Name,SkillStatus)
activeToke(none,no).

% format: enemyToke/9
% enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)
enemyToke(none,0,type,0,skill,0,0,0,no).

fight :- checkStart, !.
fight :- checkBattle(no), !.
fight :- checkDefeat, !.
fight :-
	retract(encounter(yes)),
	asserta(encounter(no)),
	write('Choose your tokemon using pick(tokemon_name).'), nl,
	!.
fight :- checkBattle(yes), !.

run :- checkStart, !.
run :- checkBattle(no), !.
run :- checkDefeat, !.
run :-
	retractall(encounter(_)),
	asserta(encounter(no)),
	write('You fled from the battle...'), nl,
	endBattle,
	!.

pick(_) :- checkStart, !.
pick(_) :- checkBattle(no), !.
pick(_) :- checkEncounter, !.
pick(_) :- checkDefeat, !.
pick(Toke) :-
	myToke(MyToke),
	searchInven(MyToke,Toke),
	retractall(activeToke(none, _)),
	asserta(activeToke(Toke, yes)),
	write('I choose you '), write(Toke), write('!!'), nl,
	write('Use attack or specialAttack?'), nl,
	!.
pick(_) :-
	write('You don\'t have that Tokemon!'), nl,
	write('Type "status." to see your Tokemons!'), nl,
	!.

attack :- checkStart, !.
attack :- checkBattle(no), !.
attack :- checkEncounter, !.
attack :- checkActiveToke, !.
attack :- checkDefeat, !.
attack :-
	activeToke(Toke, _),
	getAtt(Toke, Att),
	enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus),
	NewHP is HP - Att,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	format('~a attacks!', [Toke]), nl,
	format('~a dealt ~w damage to ~a...', [Toke, Att, Enemy]), nl,
	enemyTurn,
	!.

specialAttack :- checkStart, !.
specialAttack :- checkBattle(no), !.
specialAttack :- checkEncounter, !.
specialAttack :- checkActiveToke, !.
specialAttack :- checkDefeat, !.
specialAttack :-
	activeToke(Toke,no),
	getSkill(Toke,Skill),
	format('Your skill, ~a, has been used...', [Skill]), nl,
	!.
specialAttack :-
	activeToke(Toke, yes),
	getSkill(Toke,OurSkill),
	getSkillDmg(Toke,OurSkillDmg),
	enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus),
	NewHP is HP - OurSkillDmg,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	retract(activeToke(Toke,_)),
	asserta(activeToke(Toke,no)),
	format('~a casts ~a!', [Toke, OurSkill]), nl,
	format('~a dealt ~w damage to ~a...', [Toke, OurSkillDmg, Enemy]), nl,
	enemyTurn,
	!.

capture :- checkStart, !.
capture :- checkBattle(no), !.
capture :- checkEncounter, !.
capture :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP > 0,
	enemyToke(Enemy,_,_,_,_,_,_,_,_),
	write('~a is not defeated yet!', [Enemy]), nl,
	!.
capture :-
	enemyToke(Enemy,_,_,_,_,_,_,_,_),
	repeat,
	write('Name your new tokemon: '),
	read(Nick),
	(	uniqueNick(Nick) -> (captured(Nick, Enemy), !, fail)
	;	notCaptured(Nick)
	).

captured(_,_) :- checkStart, !.
captured(Nick, Enemy) :-
	enemyToke(Enemy,_,_,_,_,_,_,_,_),
	addTokemon(Nick, Enemy),
	format('~a is captured!', [Nick]), nl,
	endBattle.

notCaptured(_) :- checkStart, !.
notCaptured(Nick) :-
	write(Nick), write(' has been taken.'), nl,
	write('Try "'), write(Nick), write('2"?'), nl.