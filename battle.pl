capture :-
	repeat,
		write('Name your new tokemon: '),
		read(Nick),
		uniqueNick(Nick) -> (
			enemyToke(Enemy),
			Cond is captured(Nick, Enemy)
		) ; (
			Cond is notCaptured,
			write('Please enter unique name!')
		),
	Cond = captured(Nick, Enemy).

captured(Nick, Enemy) :-
	addTokemon(Nick, Enemy),
	write(Nick), write(' is captured!'), nl.
	

