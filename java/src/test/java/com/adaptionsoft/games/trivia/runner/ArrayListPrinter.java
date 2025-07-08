package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.Printer;

public class ArrayListPrinter implements Printer {

    @Override
    public void println(Object message) {
        System.out.println(message);
    }
}
