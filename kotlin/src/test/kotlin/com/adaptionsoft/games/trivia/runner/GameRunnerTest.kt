package com.adaptionsoft.games.trivia.runner


import org.junit.Test
import kotlin.test.assertEquals

class GameRunnerTest {

    @Test
    fun runTest() {
        GameRunner.main(args = arrayOf())
        assertEquals(true, true)
    }
}