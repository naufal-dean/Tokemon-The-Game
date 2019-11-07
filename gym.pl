heal :- checkStart, !.
heal :- checkBattle(yes), !.
heal :-
	at(player, R, C),
	at(gym, R, C),
	tryHeal,
	!.
heal :-
	write('You can only heal you tokemons at gym.'), nl,
	!.

tryHeal :- checkStart, !.
tryHeal :-
	healUsed(no),
	myToke(MyToke),
	healAll(MyToke),
	retract(heal(no)),
	asserta(heal(yes)),
	write('Your HP has been restored! Let\'s continue our journey!'), nl,
	!.
tryHeal :-
	write('You have used your heal chance!'), nl,
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
