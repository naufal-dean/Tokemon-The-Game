battleStarted(no).
encounter(no).

% format: activeToke(Name,SkillStatus)
activeToke(none,no).

% format: enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)
enemyToke(none,0,type,0,skill,0,0,0,no).

initBattle(_) :- checkStart, !.
initBattle(_) :- checkBattle(yes), !.
initBattle(Enemy) :-
	retract(battleStarted(no)),
	asserta(battleStarted(yes)),
	retract(encounter(no)),
	asserta(encounter(yes)),
	retractall(enemyToke(_,_,_,_,_,_,_,_,_)),
	tokeData(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level),
	asserta(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,yes)),
	format('A wild Tokemon appears! It is ~a...\nFight or Run?\n', [Enemy]).

endBattle :- checkStart, !.
endBattle :-
	retract(battleStarted(yes)),
	asserta(battleStarted(no)),
	retractall(activeToke(_)),
	asserta(activeToke(none)),
	retractall(enemyToke(_,_,_,_,_,_,_,_,_)),
	asserta(enemyToke(none,0,type,0,skill,0,0,0,no)).

checkBattle(_) :- checkStart, !.
checkBattle(no) :-
	battleStarted(no),
	write('You\'re not in a battle!\n'),
	!.
checkBattle(yes) :-
	battleStarted(yes),
	write('You have a battle await, young master!\n'),
	!.

checkEncounter :- checkStart, !.
checkEncounter :-
	encounter(yes),
	write('A wild Tokemon in front of you!\nFight or Run?\n').

checkActiveToke :- checkStart, !.
checkActiveToke :-
	activeToke(none),
	write('You must Pick a Tokemon first!\n').

enemyTurn :- checkStart, !.
enemyTurn :-
	enemyToke(Enemy,HP,_,_,_,_,_,_,_),
	HP =< 0,
	format('You defeated ~a..\nCapture or Move around to end the battle?\n', [Enemy]),
	!.
enemyTurn :-
	write('Enemy\'s turn...').

fight :- checkStart, !.
fight :- checkBattle(no), !.
fight :-
	retract(encounter(yes)),
	asserta(encounter(no)),
	write('The battle begins...\n').

run :- checkStart, !.
run :- checkBattle(no), !.
run :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,
	format('~a is defeated...\nCapture it or move to end the battle...\n', [Enemy]).
run :-
	retractall(encounter(_)),
	asserta(encounter(no)),
	write('You fled from the battle...'), nl,
	endBattle.

pick(_) :- checkStart, !.
pick(_) :- checkBattle(no), !.
pick(_) :- checkEncounter, !.
pick(_) :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,
	format('~a is defeated...\nCapture it or move to end the battle...\n', [Enemy]).
pick(Toke) :-
	myToke(MyToke),
	searchInven(MyToke,Toke),
	retract(activeToke(none)),
	asserta(activeToke(Toke)).
pick(_) :-
	write('You don\'t have that Tokemon!\n').

attack :- checkStart, !.
attack :- checkBattle(no), !.
attack :- checkEncounter, !.
attack :- checkActiveToke, !.
attack :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,
	format('~a is defeated...\nCapture it or move to end the battle...\n', [Enemy]).
attack :-
	activeToke(Toke),
	getAtt(Toke, Att),
	enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus),
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	NewHP is HP - Att,
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	format('~a attack!\n', [Toke]),
	format('~a deals ~w damage to ~a...', [Toke, Att, Enemy]),
	enemyTurn.

specialAttack :- checkStart, !.
specialAttack :- checkBattle(no), !.
specialAttack :- checkEncounter, !.
specialAttack :- checkActiveToke, !.
specialAttack :-
	activeToke(Toke,no),
	getSkill(Toke,Skill),
	format('Your skill, ~a, has been used...\n', [Skill]).
specialAttack :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,
	format('~a is defeated...\nCapture it or move to end the battle...\n', [Enemy]).
specialAttack :-
	activeToke(Toke),
	getSkill(Toke,OurSkill),
	getSkillDmg(Toke,OurSkillDmg),
	enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level),
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	NewHP is HP - OurSkillDmg,
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level,SkillStatus)),
	retract(activeToke(Toke,yes)),
	asserta(activeToke(Toke,no)),
	format('Skill ~a is used!\n', [OurSkill]),
	format('~a deals ~w damage to ~a...', [Toke, OurSkillDmg, Enemy]),
	enemyTurn.

capture :- checkStart, !.
capture :- checkBattle(no), !.
capture :- checkEncounter, !.
capture :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_,_),
	EnemyHP =< 0,
	repeat,
		write('Name your new tokemon: '),
		read(Nick),
		(uniqueNick(Nick) -> (
			enemyToke(Enemy,_,_,_,_,_,_,_,_),
			Cond is captured(Nick, Enemy)
		) ; (
			Cond is notCaptured,
			write('Please enter unique name!')
		)),
	Cond = captured(Nick, Enemy),
	endBattle,
	!.
capture :-
	enemyToke(Enemy,_,_,_,_,_,_,_,_),
	write('~a is not defeated yet!', [Enemy]).

captured(Nick, Enemy) :-
	addTokemon(Nick, Enemy),
	format('~a is captured!\n', [Nick]).
