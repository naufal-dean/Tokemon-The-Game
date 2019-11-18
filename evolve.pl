/* Exp */
/* Format: killXP(nama,xp) */
killXP(jojomon,20).
killXP(annamon,20).
killXP(deanmon,20).
killXP(hadimon,20).
killXP(doraemon,20).
% killXP(kindermon,20).
% killXP(ekomon,15).
% killXP(coremon,15).
% killXP(redomon,15).
% killXP(flodomon,15).
% killXP(branchomon,15).
% killXP(terimon,15).
% killXP(bluemon,15).
% killXP(devilomon,15).
% killXP(sunomon,15).
% killXP(hakimomon,15).
killXP(insectmon,5).
killXP(waterlemon,5).
killXP(chillmon,5).
killXP(phillipmon,5).
killXP(gelapmon,5).
killXP(flatmon,5).
killXP(orizamon,10).
killXP(icelemon,10).
killXP(papermon,10).
killXP(magentamon,10).
killXP(trashmon,10).
killXP(blokmon,10).

/* Evolve stats, attack skill_damage need nerf */
/* Format: evolveData(nama_awal,nama_evolve,hp,tipe,attack,skill,skill_damage,exp,level) */
evolveData(_,_,_,_,_,_,_,_,_) :- checkStart, !.
evolveData(jojomon,jojomonZ,90,leaves,20,'leaf typhoon super',40,0,1).
evolveData(annamon,annamonZ,108,water,17,'tsunami super',35,0,1).
evolveData(deanmon,deanmonZ,77,fire,23,'fire breath super',45,0,1).
evolveData(hadimon,hadimonZ,86,dark,17,'black hole super',60,0,1).
evolveData(doraemon,doraemonZ,84,light,18,'kantong ajaib super',50,0,1).
% evolveData(kindermon,kindermonZ,81,neutral,19,'chocho egg super',55,0,1).
% evolveData(ekomon,ekomonZ,99,leaves,21,'green shoot super',30,0,1).
% evolveData(coremon,coremonZ,85,light,18,'core bang super',52,0,1).
% evolveData(redomon,redomonZ,75,fire,22,'red flow super',40,0,1).
% evolveData(flodomon,flodomonZ,113,water,19,'super water super',30,0,1).
% evolveData(branchomon,branchomonZ,95,leaves,21,'winter attack super',42,0,1).
% evolveData(terimon,terimonZ,111,water,16,'salt combo super',34,0,1).
% evolveData(bluemon,bluemonZ,76,fire,20,'fire blue super',43,0,1).
% evolveData(devilomon,devilomonZ,81,dark,18,'hell boy super',58,0,1).
% evolveData(sunomon,sunomonZ,82,light,17,'uv brust super',55,0,1).
% evolveData(hakimomon,hakimomonZ,83,neutral,18,'truth hammer super',54,0,1).
evolveData(insectmon,insectmonZ,75,leaves,5,'acid blue super',10,0,1).
evolveData(waterlemon,waterlemonZ,90,water,4,'sweet seed super',8,0,1).
evolveData(chillmon,chillmonZ,60,fire,6,'warm candy super',12,0,1).
evolveData(phillipmon,phillipmonZ,66,light,4,'white lamp super',17,0,1).
evolveData(gelapmon,gelapmonZ,72,dark,3,'electric die super',18,0,1).
evolveData(flatmon,flatmonZ,75,neutral,4,'flatt super!!!',11,0,1).
evolveData(orizamon,orizamonZ,78,leaves,5,'yellow rice super',9,0,1).
evolveData(icelemon,icelemonZ,64,water,6,'cold acid super',7,0,1).
evolveData(papermon,papermonZ,46,fire,5,'choked super',10,0,1).
evolveData(magentamon,magentamonZ,63,light,5,'color nail super',16,0,1).
evolveData(trashmon,trashmonZ,75,dark,4,'garbage cube super',17,0,1).
evolveData(blokmon,blokmonZ,69,neutral,3,'fire freedom super',10,0,1).

/* level up */
levelUp(_) :- checkStart, !.
levelUp(Nick) :-
  getExp(Nick,Exp),
  Exp >= 15,
  getLevel(Nick,Level),
  Level < 5,
  retract(tokemon(Nick,Name,_,Type,Att,Skill,SkillDmg,_,_)),
  tokeData(Name,MaxHP,_,_,_,_,_,_),
  NewHP is MaxHP + ceiling(MaxHP * 0.3),
  NewAtt is Att + ceiling(Att * 0.25),
  NewSkillDmg is SkillDmg + ceiling(SkillDmg * 0.3),
  NewLevel is Level + 1,
  NewExp is Exp - 15,
  asserta(tokemon(Nick,Name,NewHP,Type,NewAtt,Skill,NewSkillDmg,NewExp,NewLevel)),
  format('~a grew to level ~w!!!', [Nick,NewLevel]), nl,
  levelUp(Nick),
  !.
levelUp(Nick) :-
  getLevel(Nick,Level),
  Level == 5,
  format('~a looks stronger than ever...', [Nick]), nl,
  write('You can evolve your Tokemon using evolve(tokemon_nick)'), nl,
  !.
levelUp(_).

/* Evolve, checkInvalidInput?? */
evolve(_) :- checkStart, !.
evolve(_) :- checkBattle(yes), !.
evolve(X) :- checkInvalidInput(X), !.
evolve(Nick) :-
  getLevel(Nick,Level),
  Level < 5,
  format('~a is not ready to be evolved yet...', [Nick]), nl,
  !.
evolve(Nick) :-
  retract(tokemon(Nick,Name,_,_,_,_,_,_,_)),
  evolveData(Name,EvoName,EvoHP,EvoType,EvoAtt,EvoSkill,EvoSkillDmg,EvoExp,EvoLevel),
  asserta(tokemon(Nick,EvoName,EvoHP,EvoType,EvoAtt,EvoSkill,EvoSkillDmg,EvoExp,EvoLevel)),
  write('What... The evolution is coming...'), nl,
  format('~a is evolved into ~a', [Nick,EvoName]), nl,
  !.
evolve(_) :-
  noTokemonMsg,
  !.