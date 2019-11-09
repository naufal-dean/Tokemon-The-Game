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
% pick(X) :- checkValidInput(X), !.
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
	activeToke(Toke,_),
	tokemon(Toke,_,_,OurType,Att,_,_,_,_),
	enemyToke(Enemy,HP,EnemyType,_,_,_,_,_,_),
	attackModifier(strong,OurType,EnemyType),
	ModAtt is Att + floor(Att * 0.5),
	NewHP is HP - ModAtt,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	format('~a attacks!', [Toke]), nl,
	write('It\'s super effective!'), nl,
	format('~a dealt ~w damage to ~a...', [Toke, ModAtt, Enemy]), nl,
	enemyTurn,
	!.
attack :-
	activeToke(Toke,_),
	tokemon(Toke,_,_,OurType,Att,_,_,_,_),
	enemyToke(Enemy,HP,EnemyType,_,_,_,_,_,_),
	attackModifier(weak,OurType,EnemyType),
	ModAtt is Att - floor(Att * 0.5),
	NewHP is HP - ModAtt,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	format('~a attacks!', [Toke]), nl,
	write('It\'s weak against the enemy!'), nl,
	format('~a dealt ~w damage to ~a...', [Toke, ModAtt, Enemy]), nl,
	enemyTurn,
	!.
attack :-
	activeToke(Toke,_),
	getAtt(Toke,Att),
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
	tokemon(Toke,_,_,OurType,_,OurSkill,OurSkillDmg,_,_),
	enemyToke(Enemy,HP,EnemyType,_,_,_,_,_,_),
	attackModifier(strong,OurType,EnemyType),
	ModOurSkillDmg is OurSkillDmg + floor(OurSkillDmg * 0.5),
	NewHP is HP - ModOurSkillDmg,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	retract(activeToke(Toke,yes)),
	asserta(activeToke(Toke,no)),
	format('~a casts ~a!', [Toke, OurSkill]), nl,
	write('The damage is increased! It\'s effective...'), nl,
	format('~a dealt ~w damage to ~a...', [Toke, ModOurSkillDmg, Enemy]), nl,
	enemyTurn,
	!.
specialAttack :-
	activeToke(Toke, yes),
	tokemon(Toke,_,_,OurType,_,OurSkill,OurSkillDmg,_,_),
	enemyToke(Enemy,HP,EnemyType,_,_,_,_,_,_),
	attackModifier(weak,OurType,EnemyType),
	ModOurSkillDmg is OurSkillDmg - floor(OurSkillDmg * 0.5),
	NewHP is HP - ModOurSkillDmg,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	retract(activeToke(Toke,yes)),
	asserta(activeToke(Toke,no)),
	format('~a casts ~a!', [Toke, OurSkill]), nl,
	write('Oh no! The damage is reduced...'), nl,
	format('~a dealt ~w damage to ~a...', [Toke, ModOurSkillDmg, Enemy]), nl,
	enemyTurn,
	!.
specialAttack :-
	activeToke(Toke, yes),
	getSkill(Toke,OurSkill),
	getSkillDmg(Toke,OurSkillDmg),
	enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus),
	NewHP is HP - OurSkillDmg,
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	retract(activeToke(Toke,yes)),
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
	countToke(6),
	write('You already have six tokemon \nPlease drop one of them if you want to capture this new Tokemon by using drop(<tokemon_name>'), nl,
	!.

capture :-
	enemyToke(Enemy,_,_,_,_,_,_,_,_),
	repeat,
		write('Name your new tokemon: '),
		read(Nick),
		(	uniqueNick(Nick) -> (
				!,
				enemyToke(Enemy,_,_,_,_,_,_,_,_),
				addTokemon(Nick, Enemy),
				format('~a is captured!', [Nick]), nl,
				endBattle
			) ; (
				write(Nick), write(' has been taken.'), nl,
				write('Try "'), write(Nick), write('2"?'), nl
			)
		).
