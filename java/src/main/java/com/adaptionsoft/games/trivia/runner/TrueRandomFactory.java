package com.adaptionsoft.games.trivia.runner;

import java.util.Random;

public class TrueRandomFactory implements RandomFactory
{
  public Random newRandom()
  {
    return new Random();
  }
}
