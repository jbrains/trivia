package com.adaptionsoft.games.uglytrivia;

public class Player {

    private static final int COINS_TO_WIN = 6;

    private final String name;
    private int place;
    private int purse;
    private boolean inPenaltyBox;
    private boolean gettingOutOfPenaltyBox;

    public Player(String name) {
        this.name = name;
        this.place = 0;
        this.purse = 0;
        this.inPenaltyBox = false;
        this.gettingOutOfPenaltyBox = false;
    }

    public void move(int roll, int boardSize) {
        place = (place + roll) % boardSize;
    }

    public void addCoin() {
        purse++;
    }

    public boolean hasWon() {
        return purse == COINS_TO_WIN;
    }

    public void sendToPenaltyBox() {
        inPenaltyBox = true;
    }

    public void tryToLeavePenaltyBox(int roll) {
        gettingOutOfPenaltyBox = (roll % 2 != 0);
    }

    public boolean isInPenaltyBox() {
        return inPenaltyBox;
    }

    public boolean isGettingOutOfPenaltyBox() {
        return gettingOutOfPenaltyBox;
    }

    public String getName() {
        return name;
    }

    public int getPlace() {
        return place;
    }

    public int getPurse() {
        return purse;
    }

    @Override
    public String toString() {
        return name;
    }
}