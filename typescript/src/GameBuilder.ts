import {Game} from "./game";

export class GameBuilder {
    private technoQuestion: boolean = false;
    withTechnoQuestions(){
        this.technoQuestion = true;
        return this;
    }

    build(): Game {
        return new Game(
            this.technoQuestion
        );
    }
}
