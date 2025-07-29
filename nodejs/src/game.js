const RandomInput = require('./random-input');
const ConsoleOutput = require('./console-output');

var Game = function (output) {
  this.output = output || new ConsoleOutput();
  var players = new Array();
  var places = new Array(6);
  var purses = new Array(6);
  var inPenaltyBox = new Array(6);

  var popQuestions = new Array();
  var scienceQuestions = new Array();
  var sportsQuestions = new Array();
  var rockQuestions = new Array();

  var currentPlayer = 0;
  var isGettingOutOfPenaltyBox = false;

  var didPlayerWin = function () {
    return !(purses[currentPlayer] == 6)
  };

  var currentCategory = function () {
    if (places[currentPlayer] == 0)
      return 'Pop';
    if (places[currentPlayer] == 4)
      return 'Pop';
    if (places[currentPlayer] == 8)
      return 'Pop';
    if (places[currentPlayer] == 1)
      return 'Science';
    if (places[currentPlayer] == 5)
      return 'Science';
    if (places[currentPlayer] == 9)
      return 'Science';
    if (places[currentPlayer] == 2)
      return 'Sports';
    if (places[currentPlayer] == 6)
      return 'Sports';
    if (places[currentPlayer] == 10)
      return 'Sports';
    return 'Rock';
  };

  this.createRockQuestion = function (index) {
    return "Rock Question " + index;
  };

  for (var i = 0; i < 50; i++) {
    popQuestions.push("Pop Question " + i);
    scienceQuestions.push("Science Question " + i);
    sportsQuestions.push("Sports Question " + i);
    rockQuestions.push(this.createRockQuestion(i));
  }
  ;

  this.isPlayable = function (howManyPlayers) {
    return howManyPlayers >= 2;
  };

  this.add = function (playerName) {
    players.push(playerName);
    places[this.howManyPlayers() - 1] = 0;
    purses[this.howManyPlayers() - 1] = 0;
    inPenaltyBox[this.howManyPlayers() - 1] = false;

    this.output.write(playerName + " was added");
    this.output.write("They are player number " + players.length);

    return true;
  };

  this.howManyPlayers = function () {
    return players.length;
  };


  var askQuestion = () => {
    if (currentCategory() == 'Pop')
      this.output.write(popQuestions.shift());
    if (currentCategory() == 'Science')
      this.output.write(scienceQuestions.shift());
    if (currentCategory() == 'Sports')
      this.output.write(sportsQuestions.shift());
    if (currentCategory() == 'Rock')
      this.output.write(rockQuestions.shift());
  };

  this.roll = function (roll) {
    this.output.write(players[currentPlayer] + " is the current player");
    this.output.write("They have rolled a " + roll);

    if (inPenaltyBox[currentPlayer]) {
      if (roll % 2 != 0) {
        isGettingOutOfPenaltyBox = true;

        this.output.write(players[currentPlayer] + " is getting out of the penalty box");
        places[currentPlayer] = places[currentPlayer] + roll;
        if (places[currentPlayer] > 11) {
          places[currentPlayer] = places[currentPlayer] - 12;
        }

        this.output.write(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
        this.output.write("The category is " + currentCategory());
        askQuestion();
      } else {
        this.output.write(players[currentPlayer] + " is not getting out of the penalty box");
        isGettingOutOfPenaltyBox = false;
      }
    } else {

      places[currentPlayer] = places[currentPlayer] + roll;
      if (places[currentPlayer] > 11) {
        places[currentPlayer] = places[currentPlayer] - 12;
      }

      this.output.write(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
      this.output.write("The category is " + currentCategory());
      askQuestion();
    }
  };

  this.wasCorrectlyAnswered = function () {
    if (inPenaltyBox[currentPlayer]) {
      if (isGettingOutOfPenaltyBox) {
        this.output.write('Answer was correct!!!!');
        purses[currentPlayer] += 1;
        this.output.write(players[currentPlayer] + " now has " +
            purses[currentPlayer] + " Gold Coins.");

        var winner = didPlayerWin();
        currentPlayer += 1;
        if (currentPlayer == players.length)
          currentPlayer = 0;

        return winner;
      } else {
        currentPlayer += 1;
        if (currentPlayer == players.length)
          currentPlayer = 0;
        return true;
      }


    } else {

      this.output.write("Answer was corrent!!!!");

      purses[currentPlayer] += 1;
      this.output.write(players[currentPlayer] + " now has " +
          purses[currentPlayer] + " Gold Coins.");

      var winner = didPlayerWin();

      currentPlayer += 1;
      if (currentPlayer == players.length)
        currentPlayer = 0;

      return winner;
    }
  };

  this.wrongAnswer = function () {
    this.output.write('Question was incorrectly answered');
    this.output.write(players[currentPlayer] + " was sent to the penalty box");
    inPenaltyBox[currentPlayer] = true;

    currentPlayer += 1;
    if (currentPlayer == players.length)
      currentPlayer = 0;
    return true;
  };
};

function runGame(input, output) {
  var notAWinner = false;
  var game = new Game(output);

  game.add('Chet');
  game.add('Pat');
  game.add('Sue');

  do {
    game.roll(input.die());

    if (input.responseIsCorrect()) {
      notAWinner = game.wasCorrectlyAnswered();
    } else {
      notAWinner = game.wrongAnswer();
    }
  } while (notAWinner);
}

if (require.main === module) {
  runGame(new RandomInput(), new ConsoleOutput())
}

module.exports = runGame;