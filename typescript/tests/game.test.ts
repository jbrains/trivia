import {expect} from 'chai';
import {describe, it} from 'mocha';
import {GameRunner} from '../src/game-runner';
import {GameBuilder} from "../src/GameBuilder";

describe('The test environment', () => {
    it('should pass', () => {
        expect(true).toBeTruthy()
    });

    it('should not pass', () => {
        expect(true).toBeFalsy()
    });

    it("should test techno question", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().withTechnoQuestions().build());
        expect(console.Content).toContain("Techno Question");
        expect(console.Content).not.toContain("Rock Question");
    });

    it("should test rock question by default", function () {
        const console = new ConsoleSpy();
        GameRunner.main(new GameBuilder().build());
        expect(console.Content).toContain("Rock Question");
        expect(console.Content).not.toContain("Techno Question");
    });

});
