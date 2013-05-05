exports = window ? global

exports.Game = ->
  players = new Array()
  places = new Array(6)
  purses = new Array(6)
  inPenaltyBox = new Array(6)
  popQuestions = new Array()
  scienceQuestions = new Array()
  sportsQuestions = new Array()
  rockQuestions = new Array()
  currentPlayer = 0
  isGettingOutOfPenaltyBox = false
  didPlayerWin = ->
    (purses[currentPlayer] isnt 6)

  currentCategory = ->
    return "Pop"  if places[currentPlayer] is 0
    return "Pop"  if places[currentPlayer] is 4
    return "Pop"  if places[currentPlayer] is 8
    return "Science"  if places[currentPlayer] is 1
    return "Science"  if places[currentPlayer] is 5
    return "Science"  if places[currentPlayer] is 9
    return "Sports"  if places[currentPlayer] is 2
    return "Sports"  if places[currentPlayer] is 6
    return "Sports"  if places[currentPlayer] is 10
    "Rock"

  @createRockQuestion = (index) ->
    "Rock Question " + index

  i = 0

  while i < 50
    popQuestions.push "Pop Question " + i
    scienceQuestions.push "Science Question " + i
    sportsQuestions.push "Sports Question " + i
    rockQuestions.push @createRockQuestion(i)
    i++
  @isPlayable = (howManyPlayers) ->
    howManyPlayers >= 2

  @add = (playerName) ->
    players.push playerName
    places[@howManyPlayers() - 1] = 0
    purses[@howManyPlayers() - 1] = 0
    inPenaltyBox[@howManyPlayers() - 1] = false
    console.log playerName + " was added"
    console.log "They are player number " + players.length
    true

  @howManyPlayers = ->
    players.length

  askQuestion = ->
    console.log popQuestions.shift()  if currentCategory() is "Pop"
    console.log scienceQuestions.shift()  if currentCategory() is "Science"
    console.log sportsQuestions.shift()  if currentCategory() is "Sports"
    console.log rockQuestions.shift()  if currentCategory() is "Rock"

  @roll = (roll) ->
    console.log players[currentPlayer] + " is the current player"
    console.log "They have rolled a " + roll
    if inPenaltyBox[currentPlayer]
      unless roll % 2 is 0
        isGettingOutOfPenaltyBox = true
        console.log players[currentPlayer] + " is getting out of the penalty box"
        places[currentPlayer] = places[currentPlayer] + roll
        places[currentPlayer] = places[currentPlayer] - 12  if places[currentPlayer] > 11
        console.log players[currentPlayer] + "'s new location is " + places[currentPlayer]
        console.log "The category is " + currentCategory()
        askQuestion()
      else
        console.log players[currentPlayer] + " is not getting out of the penalty box"
        isGettingOutOfPenaltyBox = false
    else
      places[currentPlayer] = places[currentPlayer] + roll
      places[currentPlayer] = places[currentPlayer] - 12  if places[currentPlayer] > 11
      console.log players[currentPlayer] + "'s new location is " + places[currentPlayer]
      console.log "The category is " + currentCategory()
      askQuestion()

  @wasCorrectlyAnswered = ->
    if inPenaltyBox[currentPlayer]
      if isGettingOutOfPenaltyBox
        console.log "Answer was correct!!!!"
        purses[currentPlayer] += 1
        console.log players[currentPlayer] + " now has " + purses[currentPlayer] + " Gold Coins."
        winner = didPlayerWin()
        currentPlayer += 1
        currentPlayer = 0  if currentPlayer is players.length
        winner
      else
        currentPlayer += 1
        currentPlayer = 0  if currentPlayer is players.length
        true
    else
      console.log "Answer was correct!!!!"
      purses[currentPlayer] += 1
      console.log players[currentPlayer] + " now has " + purses[currentPlayer] + " Gold Coins."
      winner = didPlayerWin()
      currentPlayer += 1
      currentPlayer = 0  if currentPlayer is players.length
      winner

  @wrongAnswer = ->
    console.log "Question was incorrectly answered"
    console.log players[currentPlayer] + " was sent to the penalty box"
    inPenaltyBox[currentPlayer] = true
    currentPlayer += 1
    currentPlayer = 0  if currentPlayer is players.length
    true

  @

notAWinner = false
game = new Game()
game.add "Chet"
game.add "Pat"
game.add "Sue"
loop
  game.roll Math.floor(Math.random() * 6) + 1
  if Math.floor(Math.random() * 10) is 7
    notAWinner = game.wrongAnswer()
  else
    notAWinner = game.wasCorrectlyAnswered()
  break unless notAWinner
