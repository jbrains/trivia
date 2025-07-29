package com.adaptionsoft.games.trivia

import java.util.*

class RandomInput : Input {
    private val rand = Random()
    
    override fun die(): Int {
        return rand.nextInt(5) + 1
    }
    
    override fun responseIsCorrect(): Boolean {
        return rand.nextInt(9) != 7
    }
}