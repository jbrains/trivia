const Game = require('./Game.js')


let someoneHasWon;

const game = new Game({});

game.add('Chet');
game.add('Pat');
game.add('Sue');

do {
  const roll = Math.floor(Math.random() * 6) + 1
  const isCorrectAnswer = Math.floor(Math.random() * 10) !== 7
  someoneHasWon = game.roll(roll, isCorrectAnswer)
} while (!someoneHasWon);