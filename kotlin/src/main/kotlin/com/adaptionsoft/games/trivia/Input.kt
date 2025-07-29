package com.adaptionsoft.games.trivia

interface Input {
    fun die(): Int
    fun responseIsCorrect(): Boolean
}