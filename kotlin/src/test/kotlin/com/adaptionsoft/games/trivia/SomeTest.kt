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
            Question(Category.Pop, 1),
            Question(Category.Science, 2),
            Question(Category.Sports, 3),
            Question(Category.Rock, 4),
        )

        val texts = questions.map { it.toString() }

        assertEquals("Pop Question 1", texts[0])
        assertEquals("Science Question 2", texts[1])
        assertEquals("Sports Question 3", texts[2])
        assertEquals("Rock Question 4", texts[3])
    }
}