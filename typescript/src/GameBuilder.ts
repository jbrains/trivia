import {Game} from "./game";
import {SystemConsole} from "./SystemConsole";
import {IConsole} from "./IConsole";

export class GameBuilder {
    private console: IConsole = new SystemConsole();
    private technoQuestion: boolean = false;
    withTechnoQuestions(){
        this.technoQuestion = true;
        return this;
    }

    withCustomConsole(console: IConsole): GameBuilder{
        this.console = console;
        return this;
    }

    build(): Game {
        return new Game(
            this.console,
            this.technoQuestion
        );
    }
}
