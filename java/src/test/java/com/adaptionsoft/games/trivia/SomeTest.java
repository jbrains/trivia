package com.adaptionsoft.games.trivia;

import com.adaptionsoft.games.uglytrivia.Game;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SomeTest {

    private final PrintStream originalOut = System.out;
    private ByteArrayOutputStream output;

    @BeforeEach
    public void captureOutput() {
        output = new ByteArrayOutputStream();
        System.setOut(new PrintStream(output));
    }

    @AfterEach
    public void restoreOutput() {
        System.setOut(originalOut);
    }

    @Test
    public void first_rock_question_is_numbered_from_zero() {
        Game game = new Game();
        game.add("Chet");
        game.add("Pat");

        game.roll(3);

        assertTrue(output.toString().contains("The category is Rock"));
        assertTrue(output.toString().contains("Rock Question 0"));
    }

    @Test
    public void second_rock_question_follows_the_first() {
        Game game = new Game();
        game.add("Chet");
        game.add("Pat");

        game.roll(3);
        game.wasCorrectlyAnswered();
        game.roll(3);

        assertTrue(output.toString().contains("Rock Question 1"));
    }

    @Test
    public void game_without_players_is_not_playable() {
        Game game = new Game();

        assertFalse(game.isPlayable());
    }

    @Test
    public void game_with_one_player_is_not_playable() {
        Game game = new Game();
        game.add("Chet");

        assertFalse(game.isPlayable());
    }

    @Test
    public void game_with_two_players_is_playable() {
        Game game = new Game();
        game.add("Chet");
        game.add("Pat");

        assertTrue(game.isPlayable());
    }

    @Test
    public void how_many_players_counts_added_players() {
        Game game = new Game();
        assertEquals(0, game.howManyPlayers());

        game.add("Chet");
        assertEquals(1, game.howManyPlayers());

        game.add("Pat");
        assertEquals(2, game.howManyPlayers());
    }

    @Test
    public void add_announces_the_player_number() {
        Game game = new Game();

        game.add("Chet");
        game.add("Pat");

        assertTrue(output.toString().contains("They are player number 1"));
        assertTrue(output.toString().contains("They are player number 2"));
    }

    @Test
    public void turn_goes_back_to_first_player_after_correct_answers() {
        Game game = new Game();
        game.add("Chet");
        game.add("Pat");

        game.roll(1);
        game.wasCorrectlyAnswered();
        game.roll(1);
        game.wasCorrectlyAnswered();
        game.roll(1);

        assertEquals(2, countOccurrences(output.toString(), "Chet is the current player"));
        assertEquals(1, countOccurrences(output.toString(), "Pat is the current player"));
    }

    @Test
    public void turn_goes_back_to_first_player_after_wrong_answers() {
        Game game = new Game();
        game.add("Chet");
        game.add("Pat");

        game.roll(1);
        game.wrongAnswer();
        game.roll(1);
        game.wrongAnswer();
        game.roll(1);

        assertEquals(2, countOccurrences(output.toString(), "Chet is the current player"));
        assertEquals(1, countOccurrences(output.toString(), "Pat is the current player"));
    }

    private int countOccurrences(String text, String fragment) {
        int count = 0;
        int index = text.indexOf(fragment);
        while (index != -1) {
            count++;
            index = text.indexOf(fragment, index + fragment.length());
        }
        return count;
    }
}
