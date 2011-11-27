var players = [];

var places = new Array(6),
	purses = new Array(6),
    inPenaltyBox = new Array(6);

var popQuestions = [],
    scienceQuestions = [],
	sportsQuestions = [],
	rockQuestions = [];

var currentPlayer = 0,
	isGettingOutOfPenaltyBox;
	
initialize();

function initialize() {
	for(var i = 0; i < 50; i++) {
        popQuestions.push('Pop Question ' + i);
        scienceQuestions.push('Science Question ' + i);
        sportsQuestions.push('Sports Question ' + i);
        rockQuestions.push(createRockQuestion(i));
    }
}

function createRockQuestion(index) {
    return 'Rock Question ' + index;
}

function isPlayable() {
    return (howManyPlayers() >= 2);
}

function add(playerName) {
    players.push(playerName);

    places[howManyPlayers()] = 0;
    purses[howManyPlayers()] = 0;
    inPenaltyBox[howManyPlayers()] = false;

    console.log(places[howManyPlayers()]);
    console.log(purses[howManyPlayers()]);

    console.log(playerName + ' was added');
    console.log('They are player number ' + players.length);
    return true;
}

function howManyPlayers() {
    return players.length - 1;
}

function roll(roll) {
    console.log(players[currentPlayer] + ' is the current player');
    console.log('They have rolled a ' + roll);

    if(inPenaltyBox[currentPlayer]) {
        if(roll % 2 != 0) {
            isGettingOutOfPenaltyBox = true;

            console.log(players[currentPlayer] + ' is getting out of the penalty box');
            places[currentPlayer] = places[currentPlayer] + roll;
            if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;

            console.log(players[currentPlayer]
                    + "s new location is "
                    + places[currentPlayer]);
            console.log('The category is ' + currentCategory());
            askQuestion();
        }
        else {
            console.log(players[currentPlayer] + ' is not getting out of the penalty box');
            isGettingOutOfPenaltyBox = false;
        }

    }
    else {

        places[currentPlayer] = places[currentPlayer] + roll;
        if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;

        console.log(players[currentPlayer]
                + "s new location is "
                + places[currentPlayer]);
        console.log('The category is ' + currentCategory());
        askQuestion();
    }

}

function askQuestion() {
    if (currentCategory() == 'Pop')
    {
        console.log(popQuestions[0]);
        popQuestions.splice(0, 1);
    }
    if (currentCategory() == 'Science')
    {
        console.log(scienceQuestions[0]);
        scienceQuestions.splice(0, 1);
    }
    if (currentCategory() == 'Sports')
    {
        console.log(sportsQuestions[0]);
        sportsQuestions.splice(0, 1);
    }
    if (currentCategory() == 'Rock')
    {
        console.log(rockQuestions[0]);
        rockQuestions.splice(0, 1);
    }
}


function currentCategory() {
    if(places[currentPlayer] == 0) return 'Pop';
    if(places[currentPlayer] == 4) return 'Pop';
    if(places[currentPlayer] == 8) return 'Pop';
    if(places[currentPlayer] == 1) return 'Science';
    if(places[currentPlayer] == 5) return 'Science';
    if(places[currentPlayer] == 9) return 'Science';
    if(places[currentPlayer] == 2) return 'Sports';
    if(places[currentPlayer] == 6) return 'Sports';
    if(places[currentPlayer] == 10) return 'Sports';
    return 'Rock';
}

function wasCorrectlyAnswered() {
	var winner;

    if(inPenaltyBox[currentPlayer]) {
        if(isGettingOutOfPenaltyBox) {
            console.log('Answer was correct!!!!');
            purses[currentPlayer]++;
            console.log(players[currentPlayer]
                    + ' now has '
                    + purses[currentPlayer]
                    + ' Gold Coins.');

            winner = didPlayerWin();
            currentPlayer++;
            if(currentPlayer == players.length) currentPlayer = 0;

            return winner;
        }
        else {
            currentPlayer++;
            if(currentPlayer == players.length) currentPlayer = 0;
            return true;
        }
    }
    else {
        console.log('Answer was corrent!!!!');
        purses[currentPlayer]++;
        console.log(players[currentPlayer]
                + ' now has '
                + purses[currentPlayer]
                + ' Gold Coins.');

        winner = didPlayerWin();
        currentPlayer++;
        if(currentPlayer == players.length) currentPlayer = 0;

        return winner;
    }
}

function wrongAnswer() {
    console.log('Question was incorrectly answered');
    console.log(players[currentPlayer] + ' was sent to the penalty box');
    inPenaltyBox[currentPlayer] = true;

    currentPlayer++;
    if(currentPlayer == players.length) currentPlayer = 0;
    return true;
}


function didPlayerWin() {
    return !(purses[currentPlayer] == 6);
}

exports.createRockQuestion = createRockQuestion;
exports.isPlayable = isPlayable;
exports.add = add;
exports.howManyPlayers = howManyPlayers;
exports.roll = roll;
exports.wasCorrectlyAnswered = wasCorrectlyAnswered;
exports.wrongAnswer = wrongAnswer;

