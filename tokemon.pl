/* Database Tokemon/8 */
/* Format: tokeData(nama_tokemon,hp,tipe,attack,skill,skill_damage,exp,level)
% tokeData(Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level))
/* Legendary */
tokeData(_,_,_,_,_,_,_,_) :- checkStart, !.
tokeData('Jojomon',100,leaves,20,'leaf typhoon',40,0,5).
tokeData('Annamon',120,water,17,'tsunami',35,0,5).
tokeData('Deanmon',85,fire,23,'fire breath',45,0,5).
tokeData('Hadimon',95,dark,17,'black hole',60,0,5).
tokeData('Doraemon',93,light,18,'kantong ajaib',50,0,5).

/* Normal */
tokeData('Insectmon',25,leaves,5,'acid blue',10,0,1).
tokeData('Waterlemon',30,water,4,'sweet seed',8,0,1).
tokeData('Chillmon',20,fire,6,'warm candy',12,0,1).
tokeData('Phillipmon',22,light,4,'white lamp',17,0,1).
tokeData('Gelapmon',24,dark,3,'electric die',18,0,1).
grassEnemies(['Insectmon', 'Gelapmon']).
dirtEnemies(['Insectmon', 'Gelapmon', 'Phillipmon', 'Chillmon']).
waterEnemies(['Waterlemon', 'Phillipmon']).

% owned tokemon
% format: tokemon(id,nama_tokemon,hp,tipe,attack,skill,skill_damage,exp,level)

% selektor
getName(_,_) :- checkStart, !.
getName(Nick, Name) :- tokemon(Nick,Name,_,_,_,_,_,_,_).

getHP(_,_) :- checkStart, !.
getHP(Nick, HP) :- tokemon(Nick,_,HP,_,_,_,_,_,_).

getType(_,_) :- checkStart, !.
getType(Nick, Type) :- tokemon(Nick,_,_,Type,_,_,_,_,_).

getAtt(_,_) :- checkStart, !.
getAtt(Nick, Att) :- tokemon(Nick,_,_,_,Att,_,_,_,_).

getSkill(_,_) :- checkStart, !.
getSkill(Nick, Skill) :- tokemon(Nick,_,_,_,_,Skill,_,_,_).

getSkillDmg(_,_) :- checkStart, !.
getSkillDmg(Nick, SkillDmg) :- tokemon(Nick,_,_,_,_,_,SkillDmg,_,_).

getExp(_,_) :- checkStart, !.
getExp(Nick, Exp) :- tokemon(Nick,_,_,_,_,_,_,Exp,_).

getLevel(_,_) :- checkStart, !.
getLevel(Nick, Level) :- tokemon(Nick,_,_,_,_,_,_,_,Level).

showMyTokes :- checkStart, !.
showMyTokes :-
	myToke(MyToke),
	showInven(MyToke).

showEnemies :- checkStart, !.
showEnemies :-
	enemy(Enemy),
	showInven(Enemy).