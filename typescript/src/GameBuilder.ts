import { Game } from "./game";
import { Player } from "./Player";
import { IConsole } from "./IConsole";
import { SystemConsole } from "./SystemConsole";

export class GameBuilder {
  private players: Player[] = [
    new Player("Suuuuuuue"),
    new Player("Chet"),
    new Player("Pat"),
  ];
  private console: IConsole = new SystemConsole();
  private coinGoal: number = 6;
  private technoQuestion: boolean = false;

  withPlayers(players: Player[]): GameBuilder {
    this.players = players;
    return this;
  }

  withCustomConsole(console: IConsole): GameBuilder {
    this.console = console;
    return this;
  }

  // withCoinGoal(coinGoal: number): GameBuilder {
  //   this.coinGoal = coinGoal;
  //   return this;
  // }

  // withTechnoQuestions() {
  //   this.technoQuestion = true;
  //   return this;
  // }

  build(): Game {
    return new Game(this.console, this.players);
  }
}
