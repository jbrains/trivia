package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.ConsolePrinter;
import org.approvaltests.Approvals;
import org.junit.jupiter.api.Test;

import java.util.Random;

class GameRunnerTest {

    @Test
    public void test_xxx() {
        ArrayListPrinter printer = new ArrayListPrinter();
        GameRunner.runGame(new Random(0), printer);
        Approvals.verify(printer.list);
    }

}