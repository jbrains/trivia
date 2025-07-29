package com.adaptionsoft.games.trivia

import com.adaptionsoft.games.trivia.runner.GameRunner
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.io.File

class SomeTest {

    @Test
    fun gameRunnerShouldProduceSameOutputAsReference() {

        val fakeInput = FakeFileInput("../reference/randomSeq.txt")
        val fakeOutput = FakeOutput()
        val gameRunner = GameRunner(fakeInput, fakeOutput)
        
        gameRunner.run()

        val expectedOutput = File("../reference/result.txt").readText().trim()
        val actualOutput = fakeOutput.getOutput()

        assertEquals(expectedOutput, actualOutput)
    }

    private fun parseCommaSeparatedInts(line: String): List<Int> {
        return line.split(",").filter { it.isNotEmpty() }.map { it.toInt() }
    }

    private inner class FakeFileInput(referenceFilePath: String) : Input {
        private val responses: List<Boolean>
        private val diceRolls: List<Int>
        private var responseIndex = 0
        private var diceIndex = 0
        
        init {
            val file = File(referenceFilePath)
            val lines = file.readLines()
            
            val responseValues = parseCommaSeparatedInts(lines[1])
            responses = responseValues.map { it != 7 }
            
            diceRolls = parseCommaSeparatedInts(lines[4])
        }
        
        override fun die(): Int {
            if (diceIndex >= diceRolls.size) {
                throw IndexOutOfBoundsException("No more dice rolls available")
            }
            return diceRolls[diceIndex++]
        }
        
        override fun responseIsCorrect(): Boolean {
            if (responseIndex >= responses.size) {
                throw IndexOutOfBoundsException("No more responses available")
            }
            return responses[responseIndex++]
        }
    }

    private inner class FakeOutput : Output {
        private val messages = mutableListOf<String>()
        
        override fun write(message: String) {
            messages.add(message)
        }
        
        fun getMessages(): List<String> = messages.toList()
        
        fun getOutput(): String = messages.joinToString("\n")
    }
}
