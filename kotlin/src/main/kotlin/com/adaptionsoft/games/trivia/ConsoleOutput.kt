package com.adaptionsoft.games.trivia

class ConsoleOutput : Output {
    override fun write(message: String) {
        println(message)
    }
}