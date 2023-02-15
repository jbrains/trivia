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

    it("should'nt accept a winning gold amount less than 6", function () {
        const game = new Game();
        game.askForWinningGoldAmount()
        expect(game.winningGoldAmount).to.not.be.lessThan(6);
    });

});
