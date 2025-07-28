
package com.adaptionsoft.games.trivia.runner;

import com.adaptionsoft.games.uglytrivia.Game;
import com.adaptionsoft.games.trivia.Input;
import com.adaptionsoft.games.trivia.Output;
import com.adaptionsoft.games.trivia.RandomInput;
import com.adaptionsoft.games.trivia.ConsoleOutput;

public class GameRunner {
    private final Input input;
    private final Output output;

    public GameRunner() {
        this(new RandomInput(), new ConsoleOutput());
    }

    public GameRunner(Input input, Output output) {
        this.input = input;
        this.output = output;
    }

    public void run() {
        Game aGame = new Game(output);
        
        aGame.add("Chet");
        aGame.add("Pat");
        aGame.add("Sue");
        
        boolean notAWinner;
        do {
            aGame.roll(input.die());
            
            if (!input.responseIsCorrect()) {
                notAWinner = aGame.wrongAnswer();
            } else {
                notAWinner = aGame.wasCorrectlyAnswered();
            }
        } while (notAWinner);
    }

    public static void main(String[] args) {
        new GameRunner().run();
    }
}
