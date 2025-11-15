package com.adaptionsoft.games.trivia

import com.adaptionsoft.games.uglytrivia.Category
import com.adaptionsoft.games.uglytrivia.Question
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

// diff output.md output_test.md
class SomeTest {

    @Test
    fun true_is_true() {
        assertTrue(true)
    }

    @Test
    fun question_has_proper_text() {
        val questions = listOf(
            Question(Category.POP, 1),
            Question(Category.SCIENCE, 2),
            Question(Category.SPORTS, 3),
            Question(Category.ROCK, 4),
        )
        
        val texts = questions.map { it.toString() }

        assertEquals("Pop Question 1", texts[0])
        assertEquals("Science Question 2", texts[1])
        assertEquals("Sports Question 3", texts[2])
        assertEquals("Rock Question 4", texts[3])
    }
}