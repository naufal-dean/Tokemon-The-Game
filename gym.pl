heal :- checkStart, !.
heal :- checkBattle(yes), !.
heal :-
	at(player, R, C),
	at(gym, R, C),
	tryHeal,
	!.
heal :-
	notAtGymMsg,
	!.

tryHeal :- checkStart, !.
tryHeal :-
	healUsed(no),
	myToke(MyToke),
	healAll(MyToke),
	retract(healUsed(no)),
	asserta(healUsed(yes)),
	getMaxLvToke(MyToke,MaxLevel),
	retract(healCooldown(_)),
	asserta(healCooldown(MaxLevel)),
	healedMsg,
	!.
tryHeal :-
	noHealChanceMsg,
	!.

healAll(_) :- checkStart, !.
healAll([]).
healAll([Nick|T]) :-
	tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level),
	tokeData(Name,BaseHp,_,_,_,_,_,_),
	scaleMaxHP(BaseHp,Level,NewHp),
	retract(tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level)),
	asserta(tokemon(Nick,Name,NewHp,Type,Att,Skill,SkillDmg,Exp,Level)),
	healAll(T),
	!.

healCooldownUpdate :- checkStart, !.
healCooldownUpdate :-
	healCooldown(1),
	retract(healCooldown(_)),
	asserta(healCooldown(0)),
	retract(healUsed(_)),
	asserta(healUsed(no)),
	nl, write('MIIIUUUWWWW!!!'), nl,
	write('The sirens\' sound is echoing all over the sky...'), nl,
	write('Gym has been restored...'), nl,
	write('You can heal your Tokemon once more...'), nl,
	!.
healCooldownUpdate :-
	healCooldown(N),
	NewN is N - 1,
	retract(healCooldown(_)),
	asserta(healCooldown(NewN)),
	!.
