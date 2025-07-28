package com.adaptionsoft.games.trivia;

import java.util.Random;

public class RandomInput implements Input {
    private final Random random = new Random();

    @Override
    public int die() {
        return random.nextInt(6) + 1;
    }

    @Override
    public boolean responseIsCorrect() {
        return random.nextInt(10) != 7;
    }
}