import { Game } from "./game";
import { GameBuilder } from "./GameBuilder";
import {Player} from "./Player";

export class GameRunner {
  public static main(game: Game): void {
    let notAWinner;
    do {
      game.roll(Math.floor(Math.random() * 6) + 1);

      if (Math.floor(Math.random() * 10) == 7) {
        notAWinner = game.wrongAnswer();
      } else {
        notAWinner = game.wasCorrectlyAnswered();
      }
    } while (notAWinner);
  }
}

GameRunner.main(new GameBuilder().build());
