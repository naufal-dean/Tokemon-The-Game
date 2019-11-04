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
command(drop).

% ================= MAP =================
mapSize(10, 10).

% posisi awal pemain & benda lain
at(player, 5, 5).
at(pagar, 1, 2).
at(pagar, 2, 2).
at(pagar, 3, 2).
at(gym, 4, 6).
at(jojomon, 5, 5).

% =============== POKEMON ===============
enemy([jojomon, annamon, deanmon, hadimon, doraemon]).
myToke([waterlemon]).