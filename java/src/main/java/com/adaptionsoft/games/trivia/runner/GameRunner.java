
package com.adaptionsoft.games.trivia.runner;
import java.util.Random;

import com.adaptionsoft.games.uglytrivia.Game;
import com.adaptionsoft.games.uglytrivia.Printer;


public class GameRunner {

	private static boolean notAWinner;

	public static void main(String[] args) {
		runGame(new Random());
	}

	public static void runGame(Random random) {
		Game aGame = new Game(new Printer() {
			@Override
			public void println(String message) {
				System.out.println(message);
			}
		});

		aGame.add("Chet");
		aGame.add("Pat");
		aGame.add("Sue");

		Random rand = random;

		do {

			aGame.roll(rand.nextInt(5) + 1);

			if (rand.nextInt(9) == 7) {
				notAWinner = aGame.wrongAnswer();
			} else {
				notAWinner = aGame.wasCorrectlyAnswered();
			}



		} while (notAWinner);
	}
}
