import { Game } from "./game";
import { GameBuilder } from "./GameBuilder";
import {Player} from "./Player";

export class GameRunner {
  public static main(game: Game): void {
    game.add(new Player("Chet"));
    game.add(new Player("Pat"));
    game.add(new Player("Sue"));

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
