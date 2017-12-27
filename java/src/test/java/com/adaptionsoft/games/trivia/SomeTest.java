package com.adaptionsoft.games.trivia;

import com.adaptionsoft.games.trivia.runner.GameRunner;
import org.junit.Before;
import org.junit.Test;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.URI;

import static java.nio.file.Files.readAllBytes;
import static java.nio.file.Paths.get;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class SomeTest
{

  private static final String FIXED_SEED = "100";

  @Before
  public void setUp() throws Exception
  {
    System.setOut(new PrintStream(new BufferedOutputStream(new FileOutputStream("./target/test-classes/Run.txt")), true));
  }

  @Test
  public void myfirstTest() throws Exception
  {

    GameRunner runner = new GameRunner();
    runner.main(new String[]{FIXED_SEED});

    String goldenMaster = new String(readAllBytes(get(new URI("file:///Users/msabatini/work/trivia/java/src/test/resources/GoldenMaster.txt"))));
    String theRun = new String(readAllBytes(get(new URI("file:///Users/msabatini/work/trivia/java/target/test-classes/Run.txt"))));

    assertThat(goldenMaster,is(theRun));


  }
}
