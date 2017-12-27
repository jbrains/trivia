package com.adaptionsoft.games.trivia;

import com.adaptionsoft.games.trivia.runner.GameRunner;
import com.adaptionsoft.games.trivia.runner.RandomFactory;
import com.adaptionsoft.games.uglytrivia.Game;
import org.junit.Before;
import org.junit.Test;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.URI;
import java.util.Random;

import static java.nio.file.Files.readAllBytes;
import static java.nio.file.Paths.get;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class GoldenMasterTest
{

  private static final String FIXED_SEED = "100";
  private URI A_RUN;
  private URI THE_GOLDEN_MASTER;
  private GameRunner runner;

  @Before
  public void setUp() throws Exception
  {
    A_RUN = new URI("file:///Users/msabatini/work/trivia/java/target/test-classes/Run.txt");

    System.setOut(new PrintStream(new BufferedOutputStream(new FileOutputStream(new File(A_RUN))), true));
    THE_GOLDEN_MASTER = new URI("file:///Users/msabatini/work/trivia/java/src/test/resources/GoldenMaster.txt");

    runner = new GameRunner(new Game(), new RandomFactory()
    {
      @Override
      public Random newRandom()
      {
        return new Random(Long.valueOf(FIXED_SEED));
      }
    });
  }

  @Test
  public void goldenMaster() throws Exception
  {
    runner.execute();

    String goldenMaster = new String(readAllBytes(get(THE_GOLDEN_MASTER)));
    String theRun = new String(readAllBytes(get(A_RUN)));

    assertThat(goldenMaster, is(theRun));
  }
}
