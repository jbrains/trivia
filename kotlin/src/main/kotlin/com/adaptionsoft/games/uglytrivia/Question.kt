package com.adaptionsoft.games.uglytrivia

enum class Category {
    POP,
    SCIENCE,
    SPORTS,
    ROCK
}

data class Question(val category: Category, val id: Int) {
    override fun toString(): String = "${toCategory(category)} Question $id"

    private fun toCategory(category: Category): String = category.name.toLowerCase().capitalize()
}
