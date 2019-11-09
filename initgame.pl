% Kalo nambah di sini jangan lupa masukin di reloadGame di util.pl
% ============================= POKEMON =============================
% Legendary Tokes
enemy([jojomon, annamon, deanmon, hadimon, doraemon]).

tokemon(jojomon,jojomon,100,leaves,20,'leaf typhoon',40,0,5).
tokemon(annamon,annamon,120,water,17,'tsunami',35,0,5).
tokemon(deanmon,deanmon,85,fire,23,'fire breath',45,0,5).
tokemon(hadimon,hadimon,95,dark,17,'black hole',60,0,5).
tokemon(doraemon,doraemon,93,light,18,'kantong ajaib',50,0,5).
tokemon(waterlemon,waterlemon,30,water,4,'sweet seed',8,0,1).

% Initial Player's Toke (1 normal)
myToke([waterlemon]).

% ============================== OTHER ==============================
healUsed(no).
