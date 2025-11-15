package com.adaptionsoft.games.uglytrivia

enum class Category {
    Pop,
    Science,
    Sports,
    Rock
}

data class Question(val category: Category, val id: Int) {
    override fun toString(): String = "$category Question $id"
}
