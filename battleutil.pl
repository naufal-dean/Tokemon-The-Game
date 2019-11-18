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
	format('A wild Tokemon appears! It is ~a...\n\n', [Enemy]),
	format('Health: ~w\nType: ~w\nDamage: ~w\nLevel: ~w\n\n', [HP, Type, Damage, Level]),
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

afterMath :- checkStart, !.
afterMath :-
	activeToke(Toke,_),
	enemyToke(Enemy,_,_,_,_,_,_,_,_),
	( (getLevel(Toke,Level), Level < 5) -> (
			killXP(Enemy,PlusExp),
			retract(tokemon(Toke,Name,HP,Type,Att,Skill,SkillDmg,Exp,Level)),
			NewExp is Exp + PlusExp,
			asserta(tokemon(Toke,Name,HP,Type,Att,Skill,SkillDmg,NewExp,Level)),
			format('~a gained ~w exp...', [Toke,PlusExp]), nl,
			levelUp(Toke)
		) ; (
			format('~a has maximum exp...', [Toke]), nl
		)
	),
	( (enemy(EnemyToke), searchInven(EnemyToke,Enemy)) -> (
			delTokemonUtil(EnemyToke, Enemy, NewEnemyToke),
			retract(enemy(_)),
			asserta(enemy(NewEnemyToke))
		) ; (
			true
		)
	),
	( (healUsed(yes)) -> (
			healCooldownUpdate
		) ; (
			true
		)
	).

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
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,
	format('~a has been defeated!', [Enemy]), nl,
	write('Capture it or Move around to end the battle.'), nl, nl,
	!.

attackModifier(_,_,_) :- checkStart, !.
attackModifier(strong,fire,leaves) :- !.
attackModifier(strong,leaves,water) :- !.
attackModifier(strong,water,fire) :- !.
attackModifier(strong,dark,light) :- !.
attackModifier(strong,light,dark) :- !.
attackModifier(weak,leaves,fire) :- !.
attackModifier(weak,fire,water) :- !.
attackModifier(weak,water,leaves) :- !.
attackModifier(normal,_,_) :- !.

enemyTurn :- checkStart, !.
enemyTurn :- nl, checkDefeat, !.
enemyTurn :-
	write('Enemy\'s turn...'), nl,
	random(0,4,X),
	enemyAttack(X),
	activeToke(Nick, OurSkillStts),
	getHP(Nick, OurHP),
	getType(Nick, OurType),
	enemyToke(Enemy,EnemyHP,EnemyType,_,_,_,_,_,EnemySkillStts),

	nl, nl,
	write('Your toke:'), nl,
	showBattleStats(Nick, OurHP, OurType, OurSkillStts), nl,

	write('Enemy toke:'), nl,
	showBattleStats(Enemy, EnemyHP, EnemyType, EnemySkillStts),
	!.

showBattleStats(_,_,_,_) :- checkStart, !.
showBattleStats(Nick, HP, Type, SkillStts) :-
	write(Nick), nl,
	write('Health: '), write(HP), nl,
	write('Type: '), write(Type), nl,
	write('Special Attack avalable? '), write(SkillStts), nl,
	!.

enemyAttack(_) :- checkStart, !.
enemyAttack(X) :-
	X < 1,
	enemyToke(Enemy,_,EnemyType,_,EnemySkill,EnemySkillDmg,_,_,yes),
	activeToke(Toke,_),
	tokemon(Toke,_,OurHP,OurType,_,_,_,_,_),
	attackModifier(Modifier,EnemyType,OurType),
	format('~a casts ~a upon you!', [Enemy, EnemySkill]), nl,
	(Modifier == strong -> (
			!,
			ModEnemySkillDmg is EnemySkillDmg + floor(EnemySkillDmg * 0.5),
			write('Nooo.. It\'s effective!'), nl
		) ; ( Modifier == weak -> (
						!,
						ModEnemySkillDmg is EnemySkillDmg - floor(EnemySkillDmg * 0.5),
						write('Easy! It\'s not very effective...'), nl
					) ; (
						!,
						ModEnemySkillDmg is EnemySkillDmg
					)
		)
	),
	format('~a dealt ~w skill damage to ~a...', [Enemy, ModEnemySkillDmg, Toke]), nl,
	NewHP is OurHP - ModEnemySkillDmg,
	retract(tokemon(Toke,O2,_,O4,O5,O6,O7,O8,O9)),
	asserta(tokemon(Toke,O2,NewHP,O4,O5,O6,O7,O8,O9)),
	retract(enemyToke(Enemy,En2,En3,En4,En5,En6,En7,En8,yes)),
	asserta(enemyToke(Enemy,En2,En3,En4,En5,En6,En7,En8,no)),
	isTokeLost(Toke),
	!.
enemyAttack(_) :-
	enemyToke(Enemy,_,EnemyType,EnemyDmg,_,_,_,_,_),
	activeToke(Toke,_),
	tokemon(Toke,_,OurHP,OurType,_,_,_,_,_),
	attackModifier(Modifier,EnemyType,OurType),
	format('~a attacks your ~a!', [Enemy, Toke]), nl,
	(Modifier == strong -> (
			!,
			ModEnemyDmg is EnemyDmg + floor(EnemyDmg * 0.5),
			write('It\'s hurt!'), nl
		) ; ( Modifier == weak -> (
						!,
						ModEnemyDmg is EnemyDmg - floor(EnemyDmg * 0.5),
						write('It\'s weak...'), nl
					) ; (
						!,
						ModEnemyDmg is EnemyDmg
					)
		)
	),
	format('~a dealt ~w damage to ~a...', [Enemy, ModEnemyDmg, Toke]), nl,
	NewHP is OurHP - ModEnemyDmg,
	retract(tokemon(Toke,O2,_,O4,O5,O6,O7,O8,O9)),
	asserta(tokemon(Toke,O2,NewHP,O4,O5,O6,O7,O8,O9)),
	isTokeLost(Toke),
	!.

isTokeLost(_) :- checkStart, !.
isTokeLost(Toke) :-
	tokemon(Toke,_,HP,_,_,_,_,_,_),
	HP =< 0,
	delTokemon(Toke),
	retractall(activeToke(_, _)),
	asserta(activeToke(none, no)),
	format('Noo! ~a has defeated...', [Toke]), nl,
	( \+ countToke(0) -> (
			write('You must pick another Tokemon!'), nl
		) ;
		lose
	).
isTokeLost(_).

uniqueNick(_) :- checkStart, !, fail.
uniqueNick(X) :- checkInvalidInput(X), !, fail.
uniqueNick(Nick) :-
	myToke(MyToke),
	searchInven(MyToke, Nick),
	write('You already have a pokemon with the name '), write(Nick), nl,
	write('Please choose another name!'), nl,
	!, fail.
uniqueNick(_).
