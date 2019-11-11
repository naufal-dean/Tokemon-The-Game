% =================== validasi input ===================
do(_) :- checkStart, !.
do(start) :-
  gameStarted(yes),
  ongoingGameMsg,
  !.
do(quit) :-
  quit,
  !, fail.
do(X) :-
	\+ command(X),
	invalidInputMsg,
  !.
do(X) :-
	X,
  !.

checkStart :-
  gameStarted(no),
  notStartedMsg.

isEmpty([], true).
isEmpty([_|_], false).

checkInvalidInput(X) :-
  \+ atom(X),
  write('Please enter a valid name!'), nl,
  !.

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

assertFromFile(Stream, []) :-
    at_end_of_stream(Stream), !.
assertFromFile(Stream, [H|T]) :-
    \+ at_end_of_stream(Stream), !,
    read(Stream, H),
    asserta(H),
    assertFromFile(Stream, T).

reloadGame(FileName) :-
  retractall(at(_,_,_)),
  reloadGameUtil(FileName).

reloadGameUtil(FileName) :-
  retractall(point(_,_,_)),
  retractall(playerName(_)),
  retractall(enemy(_)),
  retractall(myToke(_)),
  retractall(tokemon(_,_,_,_,_,_,_,_,_)),
  retractall(healUsed(_)),
  retractall(battleStarted(_)),
  asserta(battleStarted(no)),
  retractall(encounter(_)),
  asserta(encounter(no)),
  retractall(activeToke(_,_)),
  asserta(activeToke(none,no)),
  retractall(enemyToke(_,_,_,_,_,_,_,_,_)),
  asserta(enemyToke(none,0,type,0,skill,0,0,0,no)),

  open(FileName, read, Stream),
  assertFromFile(Stream, _),
  close(Stream).

saveGame(_) :- checkStart, !.
saveGame(FileName) :-
  open(FileName, write, Stream),
  \+ loopWrite(Stream),
  close(Stream),
  format('Your game has been saved to ~a', [FileName]), nl,
  !.

loopWrite(_) :- checkStart, !.
loopWrite(Stream) :-
  playerName(Name),
  write(Stream, playerName(Name)), write(Stream,'.'), nl(Stream),
  fail.

loopWrite(Stream) :-
  myToke(MyToke),
  write(Stream, myToke(MyToke)), write(Stream,'.'), nl(Stream),
  fail.

loopWrite(Stream) :-
  point(Terrain, R, C),
  write(Stream, point(Terrain, R, C)), write(Stream,'.'), nl(Stream),
  fail.

loopWrite(Stream) :-
  at(X, R, C),
  (X == player; X == gym; X == pagar),
  write(Stream, at(X, R, C)), write(Stream,'.'), nl(Stream),
  fail.

/*** LOADLOCAL - Loading game state from a chosen file ***/
loadGame(_) :- checkStart, !.
loadGame(FileName) :-
  reloadGame(FileName),
  placeTerrain,
  reloadGameUtil(FileName),
  format('Your game from ~a has been loaded.', [FileName]), nl.
