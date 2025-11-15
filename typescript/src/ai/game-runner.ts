require("seedrandom")("42", { global: true });
import { Game } from "./game";

const logger = (...args: string[]) => console.log(...args);

export class GameRunner {
  public static main(): void {
    const game = new Game({ logger });

    game.addPlayer("Chet");
    game.addPlayer("Pat");
    game.addPlayer("Sue");

    do {
      game.roll(Math.floor(Math.random() * 6) + 1);

      if (Math.floor(Math.random() * 10) == 7) {
        game.answerIncorrect();
      } else {
        game.answerCorrect();
      }
    } while (!game.gameWon);
  }
}

GameRunner.main();
