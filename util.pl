% validasi input
do(X) :-
	\+ command(X),
	write('Input is not valid'), nl.

do(X) :-
	X.

% read/write file
write_file(FilePath, Text) :-
  open(FilePath, write, Stream),
  write(Stream, Text), nl,
  close(Stream).

read_file(FilePath) :-
  open(FilePath, read, Stream),
  get_char(Stream, Char),
  print_stream(Char, Stream),
  close(Stream).

print_stream(end_of_file, _) :-
  !.

print_stream(Char, Stream) :-
  write(Char),
  get_char(Stream, Char2),
  print_stream(Char2, Stream).

% banner
welcomeMsg :-
	read_file('data/welcomeMsg.txt').

help :-
	read_file('data/help.txt').
