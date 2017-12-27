
package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.Game;

import java.util.Random;

public class GameRunner
{

  private static boolean notAWinner;
  private final Game game;

  public GameRunner(Game game)
  {
    this.game = game;
  }

  public void execute(String args)
  {
    game.add("Chet");
    game.add("Pat");
    game.add("Sue");

    Random rand;
    if (args != null)
    {
      rand = new Random(Long.valueOf(args));
    }
    else
      rand = new Random();

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
}
