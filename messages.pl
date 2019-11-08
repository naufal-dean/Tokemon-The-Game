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
  readFile('data/core/loseMsg.txt').

winMsg :-
  readFile('data/core/winMsg.txt').

quitGameMsg :-
  readFile('data/core/quitGameMsg.txt').

noTokemonMsg :-
  readFile('data/tokemon/noTokemonMsg.txt').


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
notAtGymMsg :-
  readFile('data/move/notAtGymMsg.txt').
healedMsg :-
  readFile('data/move/healedMsg.txt').
noHealChanceMsg :-
  readFile('data/move/noHealChanceMsg.txt').

% battle
onBattleMsg :-
  readFile('data/battle/onBattleMsg.txt').
notOnBattleMsg :-
  readFile('data/battle/notOnBattleMsg.txt').
encounterMsg :-
  readFile('data/battle/encounterMsg.txt').
noPickedTokeMsg :-
  readFile('data/battle/noPickedTokeMsg.txt').
