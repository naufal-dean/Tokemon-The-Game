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

% Fungsi Lain
switch(X, [Val:Goal|Cases]) :-
    ( X is Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).

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
  retractall(enemy(_)),
  retractall(myToke(_)),
  retractall(tokemon(_,_,_,_,_,_,_,_,_)),
  retractall(healUsed(_)),

  open(FileName, read, Stream),
  assertFromFile(Stream, _),
  close(Stream).