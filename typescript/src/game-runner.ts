import {Game} from './game';
import {RandomInput} from './input'
import {ConsoleOutput} from './output'

export class GameRunner {
    constructor(
        private input = new RandomInput(),
        private output = new ConsoleOutput()
    ) {
    }

    public static main(): void {
        new GameRunner().run();
    }

    public run() {

        const game = new Game(this.output);
        game.add("Chet");
        game.add("Pat");
        game.add("Sue");

        let notAWinner;
        do {

            game.roll(this.input.die());

            if (!this.input.responseIsCorrect()) {
                notAWinner = game.wrongAnswer();
            } else {
                notAWinner = game.wasCorrectlyAnswered();
            }

        } while (notAWinner);
    }
}

GameRunner.main();

  