allPlayers = ["Chet", "Pat", "Sue"];
var max = 6;

exports = typeof window !== "undefined" && window !== null ? window : global;

exports.Game = function () {
    players = [];
    var places = new Array(max);
    var purses = new Array(max);
    var inPenaltyBox = new Array(max);

    var popQuestions = [];
    var scienceQuestions = [];
    var sportsQuestions = [];
    var rockQuestions = [];

    var currentPlayer = 0;
    var isGettingOutOfPenaltyBox = false;

    var didPlayerWin = function () {
        return !(purses[currentPlayer] == max)
    };

    var currentCategory = function () {
        switch (places[currentPlayer]) {
            case 0:
            case 4:
            case 8:
                return { name: 'Pop', question: popQuestions.shift() };
            case 1:
            case 5:
            case 9:
                return { name: 'Science', question: scienceQuestions.shift() };
            case 2:
            case 6:
            case 10:
                return { name: 'Sports', question: sportsQuestions.shift() };
            default:
                return { name: 'Rock', question: rockQuestions.shift() };
        }
    };

    for (var i = 0; i < 50; i++) {
        popQuestions.push("Pop Question " + i);
        scienceQuestions.push("Science Question " + i);
        sportsQuestions.push("Sports Question " + i);
        rockQuestions.push("Rock Question " + i);
    };

    this.isPlayable = function (howManyPlayers) {
        return howManyPlayers >= 2;
    };

    this.add = function (playerName) {
        players.push(playerName);
        places[this.howManyPlayers()] = 0;
        purses[this.howManyPlayers()] = 0;
        inPenaltyBox[this.howManyPlayers()] = false;
        console.log(playerName + " was added");
        console.log("They are player number " + players.length);
        return true;
    };

    this.howManyPlayers = function () {
        return players.length - 1;
    };


    var askQuestion = function () {
        console.log(currentCategory().question);
    };

    this.roll = function (roll) {
        console.log(players[currentPlayer] + " is the current player");
        console.log(players[currentPlayer] + " have rolled a " + roll);
        if (inPenaltyBox[currentPlayer]) {
            if (roll % 2 != 0) {
                isGettingOutOfPenaltyBox = true;
                console.log(players[currentPlayer] + " is getting out of the penalty box");
                this.newLocation(roll);
            }
            else {
                console.log(players[currentPlayer] + " is not getting out of the penalty box");
                isGettingOutOfPenaltyBox = false;
            }
        }
        else {
            this.newLocation(roll);
        }
    };

    this.wasCorrectlyAnswered = function () {
        var winner = didPlayerWin();
        if (inPenaltyBox[currentPlayer]) {
            if (isGettingOutOfPenaltyBox) {
                this.correctAnswer();
                this.checkCurrentPlayer();
                return winner;
            }
            else {
                this.checkCurrentPlayer();
                return true;
            }
        }
        else {
            this.correctAnswer();
            this.checkCurrentPlayer();
            return winner;
        }
    };

    this.wrongAnswer = function () {
        console.log('Question was incorrectly answered.');
        console.log(players[currentPlayer] + " was sent to the penalty box.");
        inPenaltyBox[currentPlayer] = true;

        this.checkCurrentPlayer();
        return true;
    };

    this.correctAnswer = function () {
        console.log("Answer was correct!!!!");
        purses[currentPlayer] += 1;
        console.log(players[currentPlayer] + " now has " +
            purses[currentPlayer] + " Gold Coins.");
        return true;
    }

    this.newLocation = function (roll) {
        places[currentPlayer] = places[currentPlayer] + roll;
        if (places[currentPlayer] > 11) {
            places[currentPlayer] = places[currentPlayer] - 12;
        }
        console.log(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
        console.log("The category is " + currentCategory().name);
        askQuestion();
        return true;
    }

    this.checkCurrentPlayer = function () {
        currentPlayer += 1;
        if (currentPlayer == players.length)
            currentPlayer = 0;
        return true;
    }
};

exports.Start = function () {
    var notAWinner = false;
    var game = new Game();
    console.log('----Game has been created----');
    allPlayers.forEach(player => game.add(player));

    do {
        game.roll(Math.floor(Math.random() * max) + 1);
        if (Math.floor(Math.random() * 10) == 7) {
            notAWinner = game.wrongAnswer();
        }
        else {
            notAWinner = game.wasCorrectlyAnswered();
        }
        if (!notAWinner) console.log("----Game has Ended----");
    } while (notAWinner);
}