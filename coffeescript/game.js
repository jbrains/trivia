var Game, game, notAWinner;
Game = function() {
  var askQuestion, currentCategory, currentPlayer, didPlayerWin, i, inPenaltyBox, isGettingOutOfPenaltyBox, places, players, popQuestions, purses, rockQuestions, scienceQuestions, sportsQuestions;
  players = new Array();
  places = new Array(6);
  purses = new Array(6);
  inPenaltyBox = new Array(6);
  popQuestions = new Array();
  scienceQuestions = new Array();
  sportsQuestions = new Array();
  rockQuestions = new Array();
  currentPlayer = 0;
  isGettingOutOfPenaltyBox = false;
  didPlayerWin = function() {
    return purses[currentPlayer] !== 6;
  };
  currentCategory = function() {
    if (places[currentPlayer] === 0) {
      return "Pop";
    }
    if (places[currentPlayer] === 4) {
      return "Pop";
    }
    if (places[currentPlayer] === 8) {
      return "Pop";
    }
    if (places[currentPlayer] === 1) {
      return "Science";
    }
    if (places[currentPlayer] === 5) {
      return "Science";
    }
    if (places[currentPlayer] === 9) {
      return "Science";
    }
    if (places[currentPlayer] === 2) {
      return "Sports";
    }
    if (places[currentPlayer] === 6) {
      return "Sports";
    }
    if (places[currentPlayer] === 10) {
      return "Sports";
    }
    return "Rock";
  };
  this.createRockQuestion = function(index) {
    return "Rock Question " + index;
  };
  i = 0;
  while (i < 50) {
    popQuestions.push("Pop Question " + i);
    scienceQuestions.push("Science Question " + i);
    sportsQuestions.push("Sports Question " + i);
    rockQuestions.push(this.createRockQuestion(i));
    i++;
  }
  this.isPlayable = function(howManyPlayers) {
    return howManyPlayers >= 2;
  };
  this.add = function(playerName) {
    players.push(playerName);
    places[this.howManyPlayers() - 1] = 0;
    purses[this.howManyPlayers() - 1] = 0;
    inPenaltyBox[this.howManyPlayers() - 1] = false;
    console.log(playerName + " was added");
    console.log("They are player number " + players.length);
    return true;
  };
  this.howManyPlayers = function() {
    return players.length;
  };
  askQuestion = function() {
    if (currentCategory() === "Pop") {
      console.log(popQuestions.shift());
    }
    if (currentCategory() === "Science") {
      console.log(scienceQuestions.shift());
    }
    if (currentCategory() === "Sports") {
      console.log(sportsQuestions.shift());
    }
    if (currentCategory() === "Rock") {
      return console.log(rockQuestions.shift());
    }
  };
  this.roll = function(roll) {
    console.log(players[currentPlayer] + " is the current player");
    console.log("They have rolled a " + roll);
    if (inPenaltyBox[currentPlayer]) {
      if (roll % 2 !== 0) {
        isGettingOutOfPenaltyBox = true;
        console.log(players[currentPlayer] + " is getting out of the penalty box");
        places[currentPlayer] = places[currentPlayer] + roll;
        if (places[currentPlayer] > 11) {
          places[currentPlayer] = places[currentPlayer] - 12;
        }
        console.log(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
        console.log("The category is " + currentCategory());
        return askQuestion();
      } else {
        console.log(players[currentPlayer] + " is not getting out of the penalty box");
        return isGettingOutOfPenaltyBox = false;
      }
    } else {
      places[currentPlayer] = places[currentPlayer] + roll;
      if (places[currentPlayer] > 11) {
        places[currentPlayer] = places[currentPlayer] - 12;
      }
      console.log(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
      console.log("The category is " + currentCategory());
      return askQuestion();
    }
  };
  this.wasCorrectlyAnswered = function() {
    var winner;
    if (inPenaltyBox[currentPlayer]) {
      if (isGettingOutOfPenaltyBox) {
        console.log("Answer was correct!!!!");
        purses[currentPlayer] += 1;
        console.log(players[currentPlayer] + " now has " + purses[currentPlayer] + " Gold Coins.");
        winner = didPlayerWin();
        currentPlayer += 1;
        if (currentPlayer === players.length) {
          currentPlayer = 0;
        }
        return winner;
      } else {
        currentPlayer += 1;
        if (currentPlayer === players.length) {
          currentPlayer = 0;
        }
        return true;
      }
    } else {
      console.log("Answer was correct!!!!");
      purses[currentPlayer] += 1;
      console.log(players[currentPlayer] + " now has " + purses[currentPlayer] + " Gold Coins.");
      winner = didPlayerWin();
      currentPlayer += 1;
      if (currentPlayer === players.length) {
        currentPlayer = 0;
      }
      return winner;
    }
  };
  this.wrongAnswer = function() {
    console.log("Question was incorrectly answered");
    console.log(players[currentPlayer] + " was sent to the penalty box");
    inPenaltyBox[currentPlayer] = true;
    currentPlayer += 1;
    if (currentPlayer === players.length) {
      currentPlayer = 0;
    }
    return true;
  };
  return this;
};
notAWinner = false;
game = new Game();
game.add("Chet");
game.add("Pat");
game.add("Sue");
while (true) {
  game.roll(Math.floor(Math.random() * 6) + 1);
  if (Math.floor(Math.random() * 10) === 7) {
    notAWinner = game.wrongAnswer();
  } else {
    notAWinner = game.wasCorrectlyAnswered();
  }
  if (!notAWinner) {
    break;
  }
}