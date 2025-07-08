package com.adaptionsoft.games.uglytrivia;

public class ConsolePrinter implements Printer{
    @Override
    public void println(String message) {
        System.out.println(message);
    }
}
