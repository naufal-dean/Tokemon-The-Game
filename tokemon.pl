/* Database Tokemon/8 */
/* Format: tokeData(nama_tokemon,hp,tipe,attack,skill,skill_damage,exp,level)
% tokeData(Name,Hp,Type,Att,Skill,SkillDmg,Exp,Level))
/* Legendary */
tokeData(_,_,_,_,_,_,_,_) :- checkStart, !.
tokeData(jojomon,100,leaves,20,'leaf typhoon',40,0,5).
tokeData(annamon,120,water,17,'tsunami',35,0,5).
tokeData(deanmon,85,fire,23,'fire breath',45,0,5).
tokeData(hadimon,95,dark,17,'black hole',60,0,5).
tokeData(doraemon,93,light,18,'kantong ajaib',50,0,5).
tokeData(kindermon,90,neutral,19,'chocho egg',55,0,5).
tokeData(ekomon,110,leaves,21,'green shoot',30,0,5).
tokeData(coremon,94,light,18,'core bang',52,0,5).
tokeData(redomon,83,fire,22,'red flow',40,0,5).
tokeData(flodomon,125,water,19,'super water',30,0,5).
tokeData(branchomon,105,leaves,21,'winter attack',42,0,5).
tokeData(terimon,123,water,16,'salt combo',34,0,5).
tokeData(bluemon,84,fire,20,'fire blue',43,0,5).
tokeData(devilomon,90,dark,18,'hell boy',58,0,5).
tokeData(sunomon,91,light,17,'uv brust',55,0,5).
tokeData(hakimomon,92,neutral,18,'truth hammer',54,0,5).

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

grassEnemies([waterlemon, insectmon, orizamon, icelemon, magentamon, blokmon, flatmon, phillipmon]).
dirtEnemies([insectmon, gelapmon, phillipmon, chillmon, flatmon, trashmon, blokmon]).
waterEnemies([waterlemon, phillipmon, waterlemon, icelemon, icelemon, magentamon, blokmon]).
caveEnemies([trashmon, trashmon, flatmon, chillmon, chillmon, gelapmon, gelapmon, papermon]).
forestEnemies([gelapmon, insectmon, insectmon, flatmon, blokmon, orizamon, orizamon]).

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
