package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.ConsolePrinter;
import org.junit.jupiter.api.Test;

import java.util.Random;

class GameRunnerTest {

    @Test
    public void test_xxx() {
        GameRunner.runGame(new Random(0), new ConsolePrinter());
    }

}