% validasi input
do(X) :-
	\+ command(X),
	write('Input is not valid'), nl.

do(X) :-
	X.

% read/write file
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

% banner
welcomeMsg :-
	readFile('data/welcomeMsg.txt').

help :-
	readFile('data/help.txt').

notStartedMsg :-
  readFile('data/notStartedMsg.txt').

ongoingGameMsg :-
  readFile('data/ongoingGameMsg.txt').
