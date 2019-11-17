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
	encounter(no),
	activeToke(none, no),
	write('You can\'t run right now'), nl,
	write('Choose your tokemon using pick(tokemon_name).'), nl,
	!.
run :-
	myToke(MyToke),
	getMaxLvToke(MyToke,OurLevel),
	enemyToke(_,_,_,_,_,_,_,EnemyLevel,_),
	EnemyLevel >= OurLevel,
	MaxRand is ((EnemyLevel - OurLevel) * 3) + 8,
	random(0,MaxRand,X),
	runHelper(X),
	!.
run :-
	random(0,5,X),
	runHelper(X),
	!.

runHelper(_) :- checkStart, !.
runHelper(X) :-
	X < 4,
	retractall(encounter(_)),
	asserta(encounter(no)),
	write('You fled from the battle...'), nl,
	endBattle,
	!.
runHelper(_) :-
	write('The enemy won\'t let you go!'), nl,
	fight,
	!.

pick(_) :- checkStart, !.
pick(_) :- checkBattle(no), !.
pick(_) :- checkEncounter, !.
pick(_) :- checkDefeat, !.
pick(X) :- checkInvalidInput(X), !.
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
	enemyToke(Enemy,EnemyHP,EnemyType,_,_,_,_,_,_),
	attackModifier(Modifier,OurType,EnemyType),
	format('~a attacks!', [Toke]), nl,
	(Modifier == strong -> (
			!,
			ModAtt is Att + floor(Att * 0.5),
			write('It\'s super effective!'), nl
		) ; ( Modifier == weak -> (
						!,
						ModAtt is Att - floor(Att * 0.5),
						write('It\'s weak against the enemy!'), nl
					) ; (
						!,
						ModAtt is Att
					)
		)
	),
	format('~a dealt ~w damage to ~a...', [Toke, ModAtt, Enemy]), nl,
	NewHP is EnemyHP - ModAtt,
	retract(enemyToke(Enemy,_,En3,En4,En5,En6,En7,En8,En9)),
	asserta(enemyToke(Enemy,NewHP,En3,En4,En5,En6,En7,En8,En9)),
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
	enemyToke(Enemy,EnemyHP,EnemyType,_,_,_,_,_,_),
	attackModifier(Modifier,OurType,EnemyType),
	format('~a casts ~a!', [Toke, OurSkill]), nl,
	(Modifier == strong -> (
			!,
			ModOurSkillDmg is OurSkillDmg + floor(OurSkillDmg * 0.5),
			write('The damage is increased! It\'s effective...'), nl
		) ; ( Modifier == weak -> (
						!,
						ModOurSkillDmg is OurSkillDmg - floor(OurSkillDmg * 0.5),
						write('Oh no! The damage is reduced...'), nl
					) ; (
						!,
						ModOurSkillDmg is OurSkillDmg
					)
		)
	),
	format('~a dealt ~w skill damage to ~a...', [Toke, ModOurSkillDmg, Enemy]), nl,
	NewHP is EnemyHP - ModOurSkillDmg,
	retract(enemyToke(Enemy,_,En3,En4,En5,En6,En7,En8,En9)),
	asserta(enemyToke(Enemy,NewHP,En3,En4,En5,En6,En7,En8,En9)),
	retract(activeToke(Toke,yes)),
	asserta(activeToke(Toke,no)),
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
				format('~a is captured!', [Nick]), nl, nl,

				activeToke(Toke,_),
				killXP(Enemy,PlusExp),
				retract(tokemon(Toke,Name,HP,Type,Att,Skill,SkillDmg,Exp,Level)),
				NewExp is Exp + PlusExp,
				asserta(tokemon(Toke,Name,HP,Type,Att,Skill,SkillDmg,NewExp,Level)),
				format('~a gained ~w exp...', [Toke,PlusExp]), nl,
				levelUp(Toke),

				endBattle
			) ; (
				write(Nick), write(' has been taken.'), nl,
				write('Try "'), write(Nick), write('2"?'), nl
			)
		).
