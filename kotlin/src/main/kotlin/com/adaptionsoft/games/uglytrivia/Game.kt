package com.adaptionsoft.games.uglytrivia

import com.adaptionsoft.games.trivia.Output
import java.util.*

class Game(private val output: Output) {
    internal var players = ArrayList<Any>()
    internal var places = IntArray(6)
    internal var purses = IntArray(6)
    internal var inPenaltyBox = BooleanArray(6)

    internal var popQuestions = LinkedList<Any>()
    internal var scienceQuestions = LinkedList<Any>()
    internal var sportsQuestions = LinkedList<Any>()
    internal var rockQuestions = LinkedList<Any>()

    internal var currentPlayer = 0
    internal var isGettingOutOfPenaltyBox: Boolean = false

    init {
        for (i in 0..49) {
            popQuestions.addLast("Pop Question " + i)
            scienceQuestions.addLast("Science Question " + i)
            sportsQuestions.addLast("Sports Question " + i)
            rockQuestions.addLast(createRockQuestion(i))
        }
    }

    fun createRockQuestion(index: Int): String {
        return "Rock Question " + index
    }

    fun isPlayable(): Boolean {
        return howManyPlayers() >= 2
    }

    fun add(playerName: String): Boolean {


        players.add(playerName)
        places[howManyPlayers()] = 0
        purses[howManyPlayers()] = 0
        inPenaltyBox[howManyPlayers()] = false

        output.write(playerName + " was added")
        output.write("They are player number " + players.size)
        return true
    }

    fun howManyPlayers(): Int {
        return players.size
    }

    fun roll(roll: Int) {
        output.write(players[currentPlayer].toString() + " is the current player")
        output.write("They have rolled a " + roll)

        if (inPenaltyBox[currentPlayer]) {
            if (roll % 2 != 0) {
                isGettingOutOfPenaltyBox = true

                output.write(players[currentPlayer].toString() + " is getting out of the penalty box")
                places[currentPlayer] = places[currentPlayer] + roll
                if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12

                output.write(players[currentPlayer].toString()
                        + "'s new location is "
                        + places[currentPlayer])
                output.write("The category is " + currentCategory())
                askQuestion()
            } else {
                output.write(players[currentPlayer].toString() + " is not getting out of the penalty box")
                isGettingOutOfPenaltyBox = false
            }

        } else {

            places[currentPlayer] = places[currentPlayer] + roll
            if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12

            output.write(players[currentPlayer].toString()
                    + "'s new location is "
                    + places[currentPlayer])
            output.write("The category is " + currentCategory())
            askQuestion()
        }

    }

    private fun askQuestion() {
        if (currentCategory() === "Pop")
            output.write(popQuestions.removeFirst().toString())
        if (currentCategory() === "Science")
            output.write(scienceQuestions.removeFirst().toString())
        if (currentCategory() === "Sports")
            output.write(sportsQuestions.removeFirst().toString())
        if (currentCategory() === "Rock")
            output.write(rockQuestions.removeFirst().toString())
    }

    private fun currentCategory(): String {
        if (places[currentPlayer] == 0) return "Pop"
        if (places[currentPlayer] == 4) return "Pop"
        if (places[currentPlayer] == 8) return "Pop"
        if (places[currentPlayer] == 1) return "Science"
        if (places[currentPlayer] == 5) return "Science"
        if (places[currentPlayer] == 9) return "Science"
        if (places[currentPlayer] == 2) return "Sports"
        if (places[currentPlayer] == 6) return "Sports"
        if (places[currentPlayer] == 10) return "Sports"
        return "Rock"
    }

    fun wasCorrectlyAnswered(): Boolean {
        if (inPenaltyBox[currentPlayer]) {
            if (isGettingOutOfPenaltyBox) {
                output.write("Answer was correct!!!!")
                purses[currentPlayer]++
                output.write(players[currentPlayer].toString()
                        + " now has "
                        + purses[currentPlayer]
                        + " Gold Coins.")

                val winner = didPlayerWin()
                currentPlayer++
                if (currentPlayer == players.size) currentPlayer = 0

                return winner
            } else {
                currentPlayer++
                if (currentPlayer == players.size) currentPlayer = 0
                return true
            }


        } else {

            output.write("Answer was corrent!!!!")
            purses[currentPlayer]++
            output.write(players[currentPlayer].toString()
                    + " now has "
                    + purses[currentPlayer]
                    + " Gold Coins.")

            val winner = didPlayerWin()
            currentPlayer++
            if (currentPlayer == players.size) currentPlayer = 0

            return winner
        }
    }

    fun wrongAnswer(): Boolean {
        output.write("Question was incorrectly answered")
        output.write(players[currentPlayer].toString() + " was sent to the penalty box")
        inPenaltyBox[currentPlayer] = true

        currentPlayer++
        if (currentPlayer == players.size) currentPlayer = 0
        return true
    }

    private fun didPlayerWin(): Boolean {
        return purses[currentPlayer] != 6
    }
}