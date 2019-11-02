% validasi input
do(X) :-
	\+ command(X),
	write('Input is not valid'), nl.

do(X) :-
	X.

welcomeMsg :-
	write(' ____  _____  _  _  ____  __  __  _____  _  _ '), nl,
	write('(_  _)(  _  )( )/ )( ___)(  \\/  )(  _  )( \\( )'), nl,
	write('  )(   )(_)(  )  (  )__)  )    (  )(_)(  )  ( '), nl,
	write(' (__) (_____)(_)\\_)(____)(_/\\/\\_)(_____)(_)\\_)'), nl,
	write(' ____  ____   _____    _     __    _____  ___ '), nl,
	write('( _  \\(  _ \\ (  _  )  ( )   (  )  (  _  )/ __)'), nl,
	write(' )___/ )   /  )(_)(   /_\\/   )(__  )(_)(( (_-.'), nl,
	write('(__)  (_)\\_) (_____) (__/\\  (____)(_____)\\___/'), nl,
	nl,
	write('Gotta catch \'em all!'), nl,
	nl,
	write('Hello there! Welcome to the world of Tokemon! My name is Aril!'), nl,
	write('People call me the Tokemon Professor! This world is inhabited by'), nl,
	write('creatures called Tokemon! There are hundreds of Tokemon loose in'), nl,
	write('Labtek 5! You can catch them all to get stronger, but what I\'m'), nl,
	write('really interested in are the 2 legendary Tokemons, Annamon and'), nl,
	write('Naufalmon. If you can defeat or capture all those Tokemons I'), nl,
	write('will not kill you.'), nl,
	nl.

help :-
	write('Available commands:'), nl,
	write('    start. -- start the game!'), nl,
	write('    help. -- show available commands'), nl,
	write('    quit. -- quit the game'), nl,
	write('    n. s. e. w. -- move'), nl,
	write('    map.-- look at the map'), nl,
	write('    heal -- cure Tokemon in inventory if in gym center'), nl,
	write('    status. -- show your status'), nl.
	write('    save(Filename). -- save your game'), nl,
	write('    load(Filename). -- load previously saved game'), nl,
	nl,
	write('Legends:'), nl,
	write('    - X = Pagar'), nl,
	write('    - P = Player'), nl,
	write('    - G = Gym'), nl,
	nl.