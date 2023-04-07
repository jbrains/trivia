import {Game} from "./game";
import {SystemConsole} from "./SystemConsole";
import {IConsole} from "./IConsole";

export class GameBuilder {
    private console: IConsole = new SystemConsole();
    private technoQuestion: boolean = false;
    private players: string[] = ["Sue", "Chet", "Pat"];
    withTechnoQuestions(){
        this.technoQuestion = true;
        return this;
    }

    withPlayers(players: string[]): GameBuilder{
        this.players = players;
        return this;
    }

    withCustomConsole(console: IConsole): GameBuilder{
        this.console = console;
        return this;
    }

    build(): Game {
        return new Game(
            this.console,
            this.technoQuestion,
            this.players
        );
    }
}
