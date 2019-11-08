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
	healedMsg,
	!.
tryHeal :-
	noHealChanceMsg,
	!.

healAll(_) :- checkStart, !.
healAll([]).
healAll([Nick|T]) :-
	tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level),
	tokeData(Name,MaxHp,_,_,_,_,_,_),
	NewHp is MaxHp + Level * 1,
	retract(tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level)),
	asserta(tokemon(Nick,Name,NewHp,Type,Att,Skill,SkillDmg,Exp,Level)),
	healAll(T),
	!.
