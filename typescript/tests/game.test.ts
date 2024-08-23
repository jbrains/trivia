import {describe, expect, it} from 'vitest';
import {GameRunner} from '../src/game-runner';

describe('The test environment', () => {
    it('should pass', () => {
        expect(true).to.be.true;
    });

    it("should access game", function () {
        expect(GameRunner).to.not.be.undefined;
    });

});
