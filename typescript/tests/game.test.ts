import {GameBuilder} from "../src/GameBuilder";
import {ConsoleSpy} from "./ConsoleSpy";
import {GameRunner} from "../src/game-runner";

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

    it("should test one player stop game", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers(['Seul']).withCustomConsole(console).build());
        expect(console.Content).toContain("The game should contain 2 players minimum and 6 players maximum");
    });

    it("should test seven player stop game", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers(['Rémi', 'Théo', 'Nicolas', 'Florian', 'Gauthier', 'Hugo', 'Intru']).withCustomConsole(console).build());
        expect(console.Content).toContain("The game should contain 2 players minimum and 6 players maximum");
    });

    it("should test six player and play game", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers(['Rémi', 'Théo', 'Nicolas', 'Florian', 'Gauthier', 'Hugo']).withCustomConsole(console).build());
        expect(console.Content).toContain("now has 6 Gold Coins.");
    });
});
