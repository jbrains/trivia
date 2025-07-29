package com.adaptionsoft.games.trivia.runner

import com.adaptionsoft.games.trivia.Input
import com.adaptionsoft.games.trivia.Output
import com.adaptionsoft.games.trivia.RandomInput
import com.adaptionsoft.games.trivia.ConsoleOutput
import com.adaptionsoft.games.uglytrivia.Game

class GameRunner(private val input: Input, private val output: Output) {
    
    fun run() {
        val aGame = Game(output)

        aGame.add("Chet")
        aGame.add("Pat")
        aGame.add("Sue")

        var notAWinner: Boolean

        do {
            aGame.roll(input.die())

            notAWinner = if (input.responseIsCorrect()) {
                aGame.wasCorrectlyAnswered()
            } else {
                aGame.wrongAnswer()
            }

        } while (notAWinner)
    }
}

fun main(args: Array<String>) {
    val gameRunner = GameRunner(RandomInput(), ConsoleOutput())
    gameRunner.run()
}
