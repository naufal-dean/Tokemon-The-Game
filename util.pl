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
	read_file('data/welcomeMsg.txt').

help :-
	read_file('data/help.txt').

notStartedMsg :-
  read_file('data/notStartedMsg.txt').

ongoingGameMsg :-
  read_file('data/ongoingGameMsg.txt').
