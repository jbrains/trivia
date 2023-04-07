import {GameRunner} from '../src/game-runner';
import {GameBuilder} from "../src/GameBuilder";
import {ConsoleSpy} from "./ConsoleSpy";

describe('The test environment', () => {
    it("should test techno question", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withTechnoQuestions().withCustomConsole(console).build());
        expect(console.Content).toContain("Techno Question");
        expect(console.Content).not.toContain("Rock Question");
    });

    it("should test rock question by default", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withCustomConsole(console).build());
        expect(console.Content).toContain("Rock Question");
        expect(console.Content).not.toContain("Techno Question");
    });

});
