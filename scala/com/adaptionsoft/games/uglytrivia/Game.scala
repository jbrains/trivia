package com.adaptionsoft.games.uglytrivia

import java.util.{LinkedList, ArrayList}


class Game {
  var players: ArrayList[String] = new ArrayList[String]
  var places: Array[Int] = new Array[Int](6)
  var purses: Array[Int] = new Array[Int](6)
  var inPenaltyBox: Array[Boolean] = new Array[Boolean](6)
  var popQuestions: LinkedList[String] = new LinkedList[String]
  var scienceQuestions: LinkedList[String] = new LinkedList[String]
  var sportsQuestions: LinkedList[String] = new LinkedList[String]
  var rockQuestions: LinkedList[String] = new LinkedList[String]
  var currentPlayer: Int = 0
  var isGettingOutOfPenaltyBox: Boolean = false

  def initialize() {
    var i: Int = 0
    while (i < 50) {
      popQuestions.addLast("Pop Question " + i)
      scienceQuestions.addLast(("Science Question " + i))
      sportsQuestions.addLast(("Sports Question " + i))
      rockQuestions.addLast(createRockQuestion(i))
      i += 1
    }
  }

  initialize()

  def createRockQuestion(index: Int): String = "Rock Question " + index

  def isPlayable: Boolean = (howManyPlayers >= 2)

  def add(playerName: String): Boolean = {
    players.add(playerName)
    places(howManyPlayers) = 0
    purses(howManyPlayers) = 0
    inPenaltyBox(howManyPlayers) = false
    println(playerName + " was added")
    println("They are player number " + players.size)
    true
  }

  def howManyPlayers: Int = players.size

  def roll(roll: Int): Unit = {
    println(players.get(currentPlayer) + " is the current player")
    println("They have rolled a " + roll)
    if (inPenaltyBox(currentPlayer)) {
      if (roll % 2 != 0) {
        isGettingOutOfPenaltyBox = true
        println(players.get(currentPlayer) + " is getting out of the penalty box")
        places(currentPlayer) = places(currentPlayer) + roll
        if (places(currentPlayer) > 11) places(currentPlayer) = places(currentPlayer) - 12
        println(players.get(currentPlayer) + "'s new location is " + places(currentPlayer))
        println("The category is " + currentCategory)
        askQuestion
      }
      else {
        println(players.get(currentPlayer) + " is not getting out of the penalty box")
        isGettingOutOfPenaltyBox = false
      }
    }
    else {
      places(currentPlayer) = places(currentPlayer) + roll
      if (places(currentPlayer) > 11) places(currentPlayer) = places(currentPlayer) - 12
      println(players.get(currentPlayer) + "'s new location is " + places(currentPlayer))
      println("The category is " + currentCategory)
      askQuestion
    }
  }

  private def askQuestion: Unit = {
    if (currentCategory == "Pop") println(popQuestions.removeFirst)
    if (currentCategory == "Science") println(scienceQuestions.removeFirst)
    if (currentCategory == "Sports") println(sportsQuestions.removeFirst)
    if (currentCategory == "Rock") println(rockQuestions.removeFirst)
  }

  private def currentCategory: String = {
    if (places(currentPlayer) == 0) return "Pop"
    if (places(currentPlayer) == 4) return "Pop"
    if (places(currentPlayer) == 8) return "Pop"
    if (places(currentPlayer) == 1) return "Science"
    if (places(currentPlayer) == 5) return "Science"
    if (places(currentPlayer) == 9) return "Science"
    if (places(currentPlayer) == 2) return "Sports"
    if (places(currentPlayer) == 6) return "Sports"
    if (places(currentPlayer) == 10) return "Sports"
    "Rock"
  }

  def wasCorrectlyAnswered: Boolean = {
    if (inPenaltyBox(currentPlayer)) {
      if (isGettingOutOfPenaltyBox) {
        println("Answer was correct!!!!")
        purses(currentPlayer) += 1
        println(players.get(currentPlayer) + " now has " + purses(currentPlayer) + " Gold Coins.")
        var winner: Boolean = didPlayerWin
        currentPlayer += 1
        if (currentPlayer == players.size) currentPlayer = 0
        winner
      }
      else {
        currentPlayer += 1
        if (currentPlayer == players.size) currentPlayer = 0
        true
      }
    }
    else {
      println("Answer was corrent!!!!")
      purses(currentPlayer) += 1
      println(players.get(currentPlayer) + " now has " + purses(currentPlayer) + " Gold Coins.")
      var winner: Boolean = didPlayerWin
      currentPlayer += 1
      if (currentPlayer == players.size) currentPlayer = 0
      winner
    }
  }

  def wrongAnswer: Boolean = {
    println("Question was incorrectly answered")
    println(players.get(currentPlayer) + " was sent to the penalty box")
    inPenaltyBox(currentPlayer) = true
    currentPlayer += 1
    if (currentPlayer == players.size) currentPlayer = 0
    true
  }

  private def didPlayerWin: Boolean = !(purses(currentPlayer) == 6)
}