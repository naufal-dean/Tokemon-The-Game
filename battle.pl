:- dynamic(battleStarted/1, encounter/1, activeToke/1, enemyToke/8).

:- include(tokemon).

battleStarted(no).
encounter(no).
activeToke(none).
enemyToke(none,0,type,0,skill,0,0,0).

initBattle(_) :- checkStart, !.
initBattle(_) :- checkBattle(yes), !.
initBattle(Enemy) :-
	retract(battleStarted(no)),
	asserta(battleStarted(yes)),
	retract(encounter(no)),
	asserta(encounter(yes)),
	retractall(enemyToke(_,_,_,_,_,_,_,_)),
	tokemon(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level),
	asserta(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level)),
	format('A wild Tokemon appears! It is ~a...\nFight or Run?\n', [Enemy]).

endBattle :- checkStart, !.
endBattle :-
	retract(battleStarted(yes)),
	asserta(battleStarted(no)),
	retractall(activeToke(_)),
	asserta(activeToke(none)),
	retractall(enemyToke(_,_,_,_,_,_,_,_)),
	asserta(enemyToke(none,0,type,0,skill,0,0,0)).

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

enemyDefeated :- checkStart, !.
enemyDefeated :-
	write('Enemy\'s turn...'),
	!.
enemyDefeated :-
	enemyToke(Enemy,HP,_,_,_,_,_,_),
	HP =< 0,
	format('You defeated ~a..\nCapture or Move around to end the battle?\n', [Enemy]).

fight :- checkStart, !.
fight :- checkBattle(no), !.
fight :- checkEncounter, !.
fight :-
	retract(encounter(yes)),
	asserta(encounter(no)),
	write('The battle begins...\n').

run :- checkStart, !.
run :- checkBattle(no), !.
run :-
	retractall(encounter(_)),
	asserta(encounter(no)),
	endBattle.

pick(_) :- checkStart, !.
pick(_) :- checkBattle(no), !.
pick(_) :- checkEncounter, !.
pick(Toke) :-
	myToke(MyToke),
	searchInven(MyToke,Toke),
	retract(activeToke(none)),
	asserta(activeToke(Toke)).
pick(_) :-
	write('You don\'t have that Tokemon!\n').

attack :- checkStart, !.
attack :- checkBattle(no), !.
attack :- checkActiveToke, !.
attack :-
	activeToke(Toke),
	getAtt(Toke, Att),
	enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level),
	retractall(enemyToke(Enemy,HP,Type,Damage,Skill,SkillDmg,Exp,Level)),
	NewHP is HP - Att,
	asserta(enemyToke(Enemy,NewHP,Type,Damage,Skill,SkillDmg,Exp,Level)),
	format('~a attack!\n', [Toke]),
	format('~a deals ~w damage to ~a', [Toke, Att, Enemy]).

capture :- checkStart, !.
capture :- checkBattle(no), !.
capture :- checkActiveToke, !.
capture :-
	enemyToke(Enemy,EnemyHP,_,_,_,_,_,_),
	EnemyHP =< 0,
	repeat,
		write('Name your new tokemon: '),
		read(Nick),
		uniqueNick(Nick) -> (
			enemyToke(Enemy),
			Cond is captured(Nick, Enemy)
		) ; (
			Cond is notCaptured,
			write('Please enter unique name!')
		),
	Cond = captured(Nick, Enemy).
	endBattle.
capture :-
	enemyToke(Enemy,_,_,_,_,_,_,_),
	write('~a is not defeated yet!', [Enemy]).

captured(Nick, Enemy) :-
	addTokemon(Nick, Enemy),
	format('~a is captured!\n', [Nick]).
