package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.Printer;

import java.util.ArrayList;

public class ArrayListPrinter implements Printer {

    ArrayList<Object> list = new ArrayList<>();

    @Override
    public void println(Object message) {
        list.add(message);
    }
}
