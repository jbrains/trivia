exports = typeof window !== "undefined" && window !== null ? window : global;

function ConsoleOutput() {
  this.write = function(message) {
    console.log(message);
  };
}

function RandomInput() {
  this.die = function() {
    return Math.floor(Math.random() * 6) + 1;
  };

  this.responseIsCorrect = function() {
    return Math.floor(Math.random() * 10) !== 7;
  };
}

exports.Game = function(output) {
  this.output = output || new ConsoleOutput();
  var self = this;
  var players          = new Array();
  var places           = new Array(6);
  var purses           = new Array(6);
  var inPenaltyBox     = new Array(6);

  var popQuestions     = new Array();
  var scienceQuestions = new Array();
  var sportsQuestions  = new Array();
  var rockQuestions    = new Array();

  var currentPlayer    = 0;
  var isGettingOutOfPenaltyBox = false;

  var didPlayerWin = function(){
    return !(purses[currentPlayer] == 6)
  };

  var currentCategory = function(){
    if(places[currentPlayer] == 0)
      return 'Pop';
    if(places[currentPlayer] == 4)
      return 'Pop';
    if(places[currentPlayer] == 8)
      return 'Pop';
    if(places[currentPlayer] == 1)
      return 'Science';
    if(places[currentPlayer] == 5)
      return 'Science';
    if(places[currentPlayer] == 9)
      return 'Science';
    if(places[currentPlayer] == 2)
      return 'Sports';
    if(places[currentPlayer] == 6)
      return 'Sports';
    if(places[currentPlayer] == 10)
      return 'Sports';
    return 'Rock';
  };

  this.createRockQuestion = function(index){
    return "Rock Question "+index;
  };

  for(var i = 0; i < 50; i++){
    popQuestions.push("Pop Question "+i);
    scienceQuestions.push("Science Question "+i);
    sportsQuestions.push("Sports Question "+i);
    rockQuestions.push(this.createRockQuestion(i));
  };

  this.isPlayable = function(howManyPlayers){
    return howManyPlayers >= 2;
  };

  this.add = function(playerName){
    players.push(playerName);
    places[this.howManyPlayers() - 1] = 0;
    purses[this.howManyPlayers() - 1] = 0;
    inPenaltyBox[this.howManyPlayers() - 1] = false;

    this.output.write(playerName + " was added");
    this.output.write("They are player number " + players.length);

    return true;
  };

  this.howManyPlayers = function(){
    return players.length;
  };


  var askQuestion = function(){
    if(currentCategory() == 'Pop')
      self.output.write(popQuestions.shift());
    if(currentCategory() == 'Science')
      self.output.write(scienceQuestions.shift());
    if(currentCategory() == 'Sports')
      self.output.write(sportsQuestions.shift());
    if(currentCategory() == 'Rock')
      self.output.write(rockQuestions.shift());
  };

  this.roll = function(roll){
    self.output.write(players[currentPlayer] + " is the current player");
    self.output.write("They have rolled a " + roll);

    if(inPenaltyBox[currentPlayer]){
      if(roll % 2 != 0){
        isGettingOutOfPenaltyBox = true;

        self.output.write(players[currentPlayer] + " is getting out of the penalty box");
        places[currentPlayer] = places[currentPlayer] + roll;
        if(places[currentPlayer] > 11){
          places[currentPlayer] = places[currentPlayer] - 12;
        }

        self.output.write(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
        self.output.write("The category is " + currentCategory());
        askQuestion();
      }else{
        self.output.write(players[currentPlayer] + " is not getting out of the penalty box");
        isGettingOutOfPenaltyBox = false;
      }
    }else{

      places[currentPlayer] = places[currentPlayer] + roll;
      if(places[currentPlayer] > 11){
        places[currentPlayer] = places[currentPlayer] - 12;
      }

      self.output.write(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
      self.output.write("The category is " + currentCategory());
      askQuestion();
    }
  };

  this.wasCorrectlyAnswered = function(){
    if(inPenaltyBox[currentPlayer]){
      if(isGettingOutOfPenaltyBox){
        self.output.write('Answer was correct!!!!');
        purses[currentPlayer] += 1;
        self.output.write(players[currentPlayer] + " now has " +
                    purses[currentPlayer]  + " Gold Coins.");

        var winner = didPlayerWin();
        currentPlayer += 1;
        if(currentPlayer == players.length)
          currentPlayer = 0;

        return winner;
      }else{
        currentPlayer += 1;
        if(currentPlayer == players.length)
          currentPlayer = 0;
        return true;
      }



    }else{

      self.output.write("Answer was corrent!!!!");

      purses[currentPlayer] += 1;
      self.output.write(players[currentPlayer] + " now has " +
                  purses[currentPlayer]  + " Gold Coins.");

      var winner = didPlayerWin();

      currentPlayer += 1;
      if(currentPlayer == players.length)
        currentPlayer = 0;

      return winner;
    }
  };

  this.wrongAnswer = function(){
		self.output.write('Question was incorrectly answered');
		self.output.write(players[currentPlayer] + " was sent to the penalty box");
		inPenaltyBox[currentPlayer] = true;

    currentPlayer += 1;
    if(currentPlayer == players.length)
      currentPlayer = 0;
		return true;
  };
};

function GameRunner(input, output) {
  this.input = input || new RandomInput();
  this.output = output || new ConsoleOutput();

  this.run = function() {
    var game = new Game(this.output);
    game.add('Chet');
    game.add('Pat');
    game.add('Sue');

    var notAWinner;
    do {
      game.roll(this.input.die());

      if (!this.input.responseIsCorrect()) {
        notAWinner = game.wrongAnswer();
      } else {
        notAWinner = game.wasCorrectlyAnswered();
      }
    } while (notAWinner);
  };
}

exports.GameRunner = GameRunner;

if (require.main === module) {
  new GameRunner().run();
}
