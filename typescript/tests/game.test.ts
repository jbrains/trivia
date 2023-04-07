import {GameBuilder} from "../src/GameBuilder";
import {ConsoleSpy} from "./ConsoleSpy";
import {GameRunner} from "../src/game-runner";
import {Player} from "../src/Player";

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
        GameRunner.main(new GameBuilder().withPlayers([new Player('Seul')]).withCustomConsole(console).build());
        expect(console.Content).toContain("The game should contain 2 players minimum and 6 players maximum");
    });

    it("should test seven player stop game", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers([new Player('Rémi'), new Player('Théo'), new Player('Nicolas'), new Player('Florian'), new Player('Gauthier'), new Player('Hugo'), new Player('Intru')]).withCustomConsole(console).build());
        expect(console.Content).toContain("The game should contain 2 players minimum and 6 players maximum");
    });

    it("should test two player and play game", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers([new Player('Rémi'), new Player('Théo')]).withCustomConsole(console).build());
        expect(console.Content).toContain("now has 6 Gold Coins.");
    });

    it("should test six player and play game", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers([new Player('Rémi'), new Player('Théo'), new Player('Nicolas'), new Player('Florian'), new Player('Gauthier'), new Player('Hugo')]).withCustomConsole(console).build());
        expect(console.Content).toContain("now has 6 Gold Coins.");
    });

    it("should getting out of prison", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withPlayers([new Player('Rémi'), new Player("blbal")]).withFirstPlayerWithOnlyFalseAnswer().withFirstPlayerAlwaysGettingOut().withCustomConsole(console).build());
        expect(console.Content).toContain("is getting out of the penalty");
    });
});
