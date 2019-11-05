% =================== validasi input ===================
do(_) :- checkStart, !.
do(start) :-
  gameStarted(yes),
  ongoingGameMsg,
  !.

do(X) :-
	\+ command(X),
	invalidInputMsg,
  !.

do(X) :-
	X.

checkStart :-
  gameStarted(no),
  notStartedMsg.

isEmpty([], true).
isEmpty([_|_], false).

% =================== read/write file ===================
writeFile(FilePath, Text) :-
  open(FilePath, write, Stream),
  write(Stream, Text), nl,
  close(Stream).

readFile(FilePath) :-
  open(FilePath, read, Stream),
  get_char(Stream, Char),
  printStream(Char, Stream),
  close(Stream).

printStream(end_of_file, _) :-
  !.
printStream(Char, Stream) :-
  write(Char),
  get_char(Stream, Char2),
  printStream(Char2, Stream).

load_internal(FileName) :-
  retractall(at(_,_,_)),
  retract(i_am_at(_,_)),
  retractall(alive(_,_,_,_)),
  retract(player(_,_,_)),
  retract(playerInventory(_)),
  retractall(playerWeapon(_)),
  open(FileName, read, Stream),
  readfile(Stream, _),
  close(Stream).

% ===================== Messages =====================
% core
welcomeMsg :-
	readFile('data/core/welcomeMsg.txt').

help :-
	readFile('data/core/help.txt').

notStartedMsg :-
  readFile('data/core/notStartedMsg.txt').

ongoingGameMsg :-
  readFile('data/core/ongoingGameMsg.txt').

startGameMsg :-
  readFile('data/core/startGameMsg.txt').

invalidInputMsg :-
  readFile('data/core/invalidInputMsg.txt').

loseMsg :-
  readFile('data/core/failMsg.txt').

winMsg :-
  readFile('data/core/winMsg.txt').

quitGameMsg :-
  readFile('data/core/quitGameMsg.txt').
  
% move
invalidMoveMsg :-
  readFile('data/move/invalid.txt'),
  !.
moveMsg(DeltaR, DeltaC) :-
  DeltaR > 0,
  DeltaC =:= 0,
  readFile('data/move/south.txt'),
  !.
moveMsg(DeltaR, DeltaC) :-
  DeltaR < 0,
  DeltaC =:= 0,
  readFile('data/move/north.txt'),
  !.
moveMsg(DeltaR, DeltaC) :-
  DeltaR =:= 0,
  DeltaC > 0,
  readFile('data/move/east.txt'),
  !.
moveMsg(DeltaR, DeltaC) :-
  DeltaR =:= 0,
  DeltaC < 0,
  readFile('data/move/west.txt'),
  !.
moveMsg(_,_) :-
  readFile('data/move/cheat.txt').
