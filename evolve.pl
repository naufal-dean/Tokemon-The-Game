/* Exp */
/* Format: killXP(nama,xp) */
/* Legendary */
killXP(jojomon,20).
killXP(annamon,20).
killXP(deanmon,20).
killXP(hadimon,20).
killXP(doraemon,20).

/* Normal */
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
killXP(kindermon,15).
killXP(ekomon,15).
killXP(coremon,15).
killXP(redomon,15).
killXP(flodomon,15).
killXP(branchomon,15).
killXP(terimon,15).
killXP(bluemon,15).
killXP(devilomon,15).
killXP(sunomon,15).
killXP(hakimomon,15).

/* Evolve stats, attack skill_damage need nerf */
/* Format: evolveData(nama_awal,nama_evolve,hp,tipe,attack,skill,skill_damage,exp,level) */
/* Legendary */
evolveData(_,_,_,_,_,_,_,_,_) :- checkStart, !.
evolveData(jojomon,jojomonZ,90,leaves,19,'leaf typhoon SUPER',40,0,1).
evolveData(annamon,annamonZ,108,water,16,'tsunami SUPER',35,0,1).
evolveData(deanmon,deanmonZ,77,fire,22,'fire breath SUPER',45,0,1).
evolveData(hadimon,hadimonZ,86,dark,16,'black hole SUPER',60,0,1).
evolveData(doraemon,doraemonZ,84,light,17,'kantong ajaib SUPER',50,0,1).

/* Normal */
evolveData(insectmon,insectmonZ,63,leaves,11,'acid blue SUPER',25,0,1).
evolveData(waterlemon,waterlemonZ,75,water,9,'sweet seed SUPER',20,0,1).
evolveData(chillmon,chillmonZ,50,fire,13,'warm candy SUPER',30,0,1).
evolveData(phillipmon,phillipmonZ,55,light,9,'white lamp SUPER',43,0,1).
evolveData(gelapmon,gelapmonZ,60,dark,7,'electric die SUPER',45,0,1).
evolveData(flatmon,flatmonZ,63,neutral,9,'flatt SUPER!!!',28,0,1).
evolveData(orizamon,orizamonZ,65,leaves,11,'yellow rice SUPER',23,0,1).
evolveData(icelemon,icelemonZ,80,water,13,'cold acid SUPER',18,0,1).
evolveData(papermon,papermonZ,58,fire,11,'choked SUPER',25,0,1).
evolveData(magentamon,magentamonZ,53,light,11,'color nail SUPER',40,0,1).
evolveData(trashmon,trashmonZ,63,dark,9,'garbage cube SUPER',43,0,1).
evolveData(blokmon,blokmonZ,58,neutral,7,'fire freedom SUPER',25,0,1).
evolveData(kindermon,kindermonZ,70,neutral,19,'chocho egg SUPER',38,0,1).
evolveData(ekomon,ekomonZ,80,leaves,19,'green shoot SUPER',33,0,1).
evolveData(coremon,coremonZ,73,light,17,'core bang SUPER',38,0,1).
evolveData(redomon,redomonZ,75,fire,19,'red flow SUPER',35,0,1).
evolveData(flodomon,flodomonZ,88,water,15,'super water SUPER',35,0,1).
evolveData(branchomon,branchomonZ,78,leaves,17,'winter attack SUPER',40,0,1).
evolveData(terimon,terimonZ,85,water,15,'salt combo SUPER',33,0,1).
evolveData(bluemon,bluemonZ,70,fire,17,'fire blue SUPER',43,0,1).
evolveData(devilomon,devilomonZ,70,dark,17,'hell boy SUPER',43,0,1).
evolveData(sunomon,sunomonZ,68,light,19,'uv brust SUPER',43,0,1).
evolveData(hakimomon,hakimomonZ,73,neutral,17,'truth hammer SUPER',45,0,1).

/* level up */
levelUp(_) :- checkStart, !.
levelUp(Nick) :-
  getExp(Nick,Exp),
  getLevel(Nick,Level),
  expLimit(Level,ExpLimit),
  Exp >= ExpLimit,
  Level < 5,
  retract(tokemon(Nick,Name,_,Type,Att,Skill,SkillDmg,_,_)),
  tokeData(Name,BaseHP,_,_,_,_,_,_),
  NewAtt is Att + ceiling(Att * 0.25),
  NewSkillDmg is SkillDmg + ceiling(SkillDmg * 0.3),
  NewLevel is Level + 1,
  NewExp is Exp - ExpLimit,
  scaleMaxHP(BaseHP,NewLevel,NewHP),
  asserta(tokemon(Nick,Name,NewHP,Type,NewAtt,Skill,NewSkillDmg,NewExp,NewLevel)),
  format('~a grew to level ~w!!!', [Nick,NewLevel]), nl,
  levelUp(Nick),
  !.
levelUp(Nick) :-
  getLevel(Nick,Level),
  Level == 5,
  getName(Nick,Name),
  evolveData(_,Name,_,_,_,_,_,_,_),
  write('The earth is rumbling...'), nl,
  format('~a reached maximum strength...', [Nick]), nl,
  !.
levelUp(Nick) :-
  getLevel(Nick,Level),
  Level == 5,
  format('~a looks stronger than ever...', [Nick]), nl,
  write('You can evolve your Tokemon using evolve(tokemon_nick)'), nl,
  !.
levelUp(_).

scaleMaxHP(_,_,_) :- checkStart, !.
scaleMaxHP(BaseHP,1,BaseHP).
scaleMaxHP(BaseHP,Level,NewHP) :-
  MidHP is BaseHP + ceiling(BaseHP * 0.3),
  MidLv is Level - 1,
  scaleMaxHP(MidHP,MidLv,NewHP),
  !.

expLimit(_,_) :- checkStart, !.
expLimit(1,5).
expLimit(2,10).
expLimit(3,15).
expLimit(4,20).
expLimit(5,999).

/* Evolve */
evolve(_) :- checkStart, !.
evolve(_) :- checkBattle(yes), !.
evolve(X) :- checkInvalidInput(X), !.
evolve(Nick) :-
  getName(Nick,Name),
  evolveData(_,Name,_,_,_,_,_,_,_),
  format('You can not evolve ~a anymore!', [Nick]), nl,
  !.
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
