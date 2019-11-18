/* Database Tokemon/8 */
/* Format: tokeData(nama_tokemon,hp,tipe,attack,skill,skill_damage,exp,level)
% tokeData(Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level))
/* Legendary */
tokeData(_,_,_,_,_,_,_,_) :- checkStart, !.
tokeData(jojomon,100,leaves,20,'leaf typhoon',40,15,5).
tokeData(annamon,120,water,17,'tsunami',35,15,5).
tokeData(deanmon,85,fire,23,'fire breath',45,15,5).
tokeData(hadimon,95,dark,17,'black hole',60,15,5).
tokeData(doraemon,93,light,18,'kantong ajaib',50,15,5).

/* Normal */
tokeData(insectmon,25,leaves,5,'acid blue',10,0,1).
tokeData(waterlemon,30,water,4,'sweet seed',8,0,1).
tokeData(chillmon,20,fire,6,'warm candy',12,0,1).
tokeData(phillipmon,22,light,4,'white lamp',17,0,1).
tokeData(gelapmon,24,dark,3,'electric die',18,0,1).
tokeData(flatmon,25,neutral,4,'flatt!!!',11,0,1).
tokeData(orizamon,26,leaves,5,'yellow rice',9,0,1).
tokeData(icelemon,32,water,6,'cold acid',7,0,1).
tokeData(papermon,23,fire,5,'choked',10,0,1).
tokeData(magentamon,21,light,5,'color nail',16,0,1).
tokeData(trashmon,25,dark,4,'garbage cube',17,0,1).
tokeData(blokmon,23,neutral,3,'fire freedom',10,0,1).
tokeData(kindermon,28,neutral,9,'chocho egg',15,0,1).
tokeData(ekomon,32,leaves,9,'green shoot',13,0,1).
tokeData(coremon,29,light,8,'core bang',15,0,1).
tokeData(redomon,30,fire,9,'red flow',14,0,1).
tokeData(flodomon,35,water,7,'super water',14,0,1).
tokeData(branchomon,31,leaves,8,'winter attack',16,0,1).
tokeData(terimon,34,water,7,'salt combo',13,0,1).
tokeData(bluemon,28,fire,8,'fire blue',17,0,1).
tokeData(devilomon,28,dark,8,'hell boy',17,0,1).
tokeData(sunomon,27,light,9,'uv brust',17,0,1).
tokeData(hakimomon,29,neutral,8,'truth hammer',18,0,1).

grassEnemies([waterlemon, insectmon, orizamon, icelemon, magentamon, blokmon, flatmon, phillipmon, kindermon, coremon, branchomon, bluemon, hakimomon]).
dirtEnemies([insectmon, gelapmon, phillipmon, chillmon, flatmon, trashmon, blokmon, kindermon, redomon, branchomon, devilomon]).
waterEnemies([waterlemon, phillipmon, waterlemon, icelemon, icelemon, magentamon, blokmon, ekomon, redomon, terimon, devilomon]).
caveEnemies([trashmon, trashmon, flatmon, chillmon, chillmon, gelapmon, gelapmon, papermon, ekomon, flodomon, terimon, sunomon]).
forestEnemies([gelapmon, insectmon, insectmon, flatmon, blokmon, orizamon, orizamon, coremon, flodomon, bluemon, sunomon, hakimomon]).

% owned tokemon
% tokemon/9
% format: tokemon(Nick,Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level)

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
