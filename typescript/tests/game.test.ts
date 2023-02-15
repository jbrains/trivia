
import {expect} from 'chai';
import {describe, it} from 'mocha';
import { Game } from '../src/game';
import {GameRunner} from '../src/game-runner';

describe('The test environment', () => {
    it('should pass', () => {
        expect(true).to.be.true;
    });

    it("should access game", function () {
        expect(GameRunner).to.not.be.undefined;
    });


    it('should not add the 7th player', () => {

        const game = new Game();
        expect(game.add("a")).to.be.true;
        expect(game.add("b")).to.be.true;
        expect(game.add("c")).to.be.true;
        expect(game.add("d")).to.be.true;
        expect(game.add("e")).to.be.true;
        expect(game.add("f")).to.be.true;

        expect(game.add("g")).to.be.false;
  });
    it("should'nt accept a winning gold amount less than 6", function () {
        const game = new Game();
        game.askForWinningGoldAmount()
        expect(game.winningGoldAmount).to.not.be.lessThan(6);

    });

});
