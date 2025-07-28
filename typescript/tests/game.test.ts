import {describe, expect, it} from 'vitest';
import {GameRunner} from '../src/game-runner';
import {readFileSync} from 'fs';
import {join} from 'path';
import {Output} from '../src/output'
import {Input} from '../src/input'

class FakeOutput implements Output {
    public messages: string[] = [];
    
    public write(message: string): void {
        this.messages.push(message);
    }

    public actualMessages() {
        return this.messages.join('\n');
    }

    public static expectedMessages() : string {
        return readFileSync(join(__dirname, '../../reference/result.txt'), 'utf-8').trim();
    }
}

class FakeFileInput implements Input {
    private rolls : number[] = []
    private responses: number[] = []
    
    constructor() {
        const lines = FakeFileInput.loadLines();
        this.responses = this.parseLine(lines[1]);
        this.rolls = this.parseLine(lines[4]);
    }

    die(): number {
        return this.rolls.shift();
    }
    responseIsCorrect(): boolean {
        return this.responses.shift() !== 7;
    }

    private static loadLines() {
        return readFileSync(join(__dirname, '../../reference/randomSeq.txt'), 'utf-8').trim().split('\n');
    }

    private parseLine(line) : number[] {
        return line.split(',').map(n => parseInt(n.trim())).filter(n => !isNaN(n));
    }


}



describe('The test environment', () => {
    it('should reproduce reference output', () => {
        let fakeOutput = new FakeOutput();

        new GameRunner(
            new FakeFileInput(),
            fakeOutput
        ).run();

        expect(fakeOutput.actualMessages()).toBe(FakeOutput.expectedMessages())
    });
});
