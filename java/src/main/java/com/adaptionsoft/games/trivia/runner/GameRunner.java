
package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.Game;

import java.util.Random;

public class GameRunner
{

  private static boolean notAWinner;
  private final Game game;
  private final RandomFactory randomFactory;

  public GameRunner(Game game, RandomFactory randomFactory)
  {
    this.game = game;
    this.randomFactory = randomFactory;
  }

  public void execute(String args)
  {
    game.add("Chet");
    game.add("Pat");
    game.add("Sue");

    Random rand = randomFactory.newRandom(args);

    do
    {

      game.roll(rand.nextInt(5) + 1);

      if (rand.nextInt(9) == 7)
      {
        notAWinner = game.wrongAnswer();
      }
      else
      {
        notAWinner = game.wasCorrectlyAnswered();
      }

    }
    while (notAWinner);

  }

  public static class RandomFactory
  {

    public Random newRandom(String args)
    {
      Random rand;
      if (args != null)
      {
        rand = new Random(Long.valueOf(args));
      }
      else
        rand = new Random();
      return rand;
    }
  }
}
