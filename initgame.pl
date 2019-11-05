% daftar command yang valid
command(start).
command(quit).
command(help).
command(map).
command(n).
command(e).
command(w).
command(s).
command(status).
command(drop(_)).
command(fight).
command(run).
command(attack).
command(specialAttack).
command(capture).
command(pick(_)).

% ================= MAP =================
mapSize(10, 10).

% posisi awal pemain & benda lain
at(player, 5, 5).
at(fence, 1, 2).
at(fence, 2, 2).
at(fence, 3, 2).
at(gym, 4, 6).
at(grass, 7, 8).

% =============== POKEMON ===============
enemy(['Jojomon', 'Annamon', 'Deanmon', 'Hadimon', 'Doraemon']).
myToke(['Waterlemon']).

tokemon('Jojomon','Jojomon',100,leaves,20,'leaf typhoon',40,0,5).
tokemon('Annamon','Annamon',120,water,17,'tsunami',35,0,5).
tokemon('Deanmon','Deanmon',85,fire,23,'fire breath',45,0,5).
tokemon('Hadimon','Hadimon',95,dark,17,'black hole',60,0,5).
tokemon('Doraemon','Doraemon',93,light,18,'kantong ajaib',50,0,5).
tokemon('Waterlemon','Waterlemon',30,water,4,'sweet seed',8,0,1).