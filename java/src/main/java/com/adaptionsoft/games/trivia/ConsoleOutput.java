package com.adaptionsoft.games.trivia;

public class ConsoleOutput implements Output {
    @Override
    public void write(String message) {
        System.out.println(message);
    }
}