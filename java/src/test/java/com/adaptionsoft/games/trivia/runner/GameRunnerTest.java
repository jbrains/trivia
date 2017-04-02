package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.Game;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;

/**
 * Created by clay on 10/17/16.
 */
public class GameRunnerTest {

    GameRunner runner;

    private ByteArrayOutputStream baos;
    private PrintStream oldPrintStream;

    @Before
    public void setUp()
    {
        runner = new GameRunner();

        // From StackOverflow code by Ernest Friedman-Hill
        // Create a stream to hold the output
        baos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(baos);
        // IMPORTANT: Save the old System.out!
        oldPrintStream = System.out;
        // Tell Java to use your special stream
        System.setOut(ps);
    }

    @After
    public void tearDown()
    {
        // Undo outstream capture in setUp
        System.setOut(oldPrintStream);
    }

    @Test
    public void goldenRuleTest() {
        boolean needGolden = false;
        byte[] goldenbytes = null;
        try {
            Path goldenpath = Paths.get("golden.txt");
            goldenbytes = Files.readAllBytes(goldenpath);
        } catch (IOException e) {
            needGolden = true;
        }

        if (needGolden) {
            try {
                createGoldenRule();
            } catch (IOException e) {
                System.err.print("Could not create Golden Rule");
            }
            fail();
        }

        runGame();

        String actual = new String(baos.toByteArray());
        String golden = new String(goldenbytes);
        assertThat(actual, is(golden));

    }

    private void runGame() {
        String[] args = {"GameRunner", "33"};
        runner.main(args);
    }

    private void createGoldenRule() throws IOException {
        runGame();
        FileOutputStream out = new FileOutputStream("golden.txt");
        out.write(baos.toString().getBytes());
        out.close();
    }
}