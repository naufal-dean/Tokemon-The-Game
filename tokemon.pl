/* Database Tokemon/8 */
/* Format: tokemon(nama_tokemon,hp,tipe,attack,skill,skill_damage,exp,level)
/* Legendary */
tokemon(_,_,_,_,_,_,_,_) :- checkStart, !.
tokemon('jojomon',100,leaves,20,'leaf typhoon',40,0,5).
tokemon('annamon',120,water,17,'tsunami',35,0,5).
tokemon('deanmon',85,fire,23,'fire breath',45,0,5).
tokemon('hadimon',95,dark,17,'black hole',60,0,5).
tokemon('doraemon',93,light,18,'kantong ajaib',50,0,5).

/* Normal */
tokemon('insectmon',25,leaves,5,'acid blue',10,0,1).
tokemon('waterlemon',30,water,4,'sweet seed',8,0,1).
tokemon('chillmon',20,fire,6,'warm candy',12,0,1).
tokemon('phillipmon',22,light,4,'white lamp',17,0,1).
tokemon('gelapmon',24,dark,3,'electric die',18,0,1).

% selektor
getHP(_,_) :- checkStart, !.
getHP(Name, HP) :- tokemon(Name, HP,_,_,_,_,_,_).

getType(_,_) :- checkStart, !.
getType(Name, Type) :- tokemon(Name, _, Type,_,_,_,_,_).

getAtt(_,_) :- checkStart, !.
getAtt(Name, Att) :- tokemon(Name, _,_, Att,_,_,_,_).

getSkill(_,_) :- checkStart, !.
getSkill(Name, Skill) :- tokemon(Name, _,_,_, Skill,_,_,_).

getSkillDmg(_,_) :- checkStart, !.
getSkillDmg(Name, SkillDmg) :- tokemon(Name, _,_,_,_, SkillDmg,_,_).

getExp(_,_) :- checkStart, !.
getExp(Name, Exp) :- tokemon(Name, _,_,_,_,_, Exp,_).

getLevel(_,_) :- checkStart, !.
getLevel(Name, Level) :- tokemon(Name, _,_,_,_,_,_, Level).

showMyTokes :- checkStart, !.
showMyTokes :-
	myToke(MyToke),
	showInven(MyToke).

showEnemies :- checkStart, !.
showEnemies :-
	enemy(Enemy),
	showInven(Enemy).

drop(_) :- checkStart, !.
drop(Toke) :-
	myToke(MyToke),
	delTokemon(MyToke, Toke, NewToke),
	retract(myToke(_)),
	asserta(myToke(NewToke)),
	write('You have dropped '), write(Toke),
	!.
drop(_) :-
	write('You dont have that tokemon!'), nl.