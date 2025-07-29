const Should = require('should');
const runGame = require('./game.js');
const path = require('path');
const fs = require('fs');


class FakeFileInput {
  constructor(referenceFilePath) {
    this.loadReferenceData(referenceFilePath);
  }

  loadReferenceData(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const lines = content.split('\n');

      this.responses = FakeFileInput.parseLine(lines[1]);
      this.diceRolls = FakeFileInput.parseLine(lines[4]);

    } catch (error) {
      throw new Error(`Failed to load reference data from ${filePath}: ${error.message}`);
    }
  }

  static parseLine(line) {
    return line.split(',')
        .map(s => s.trim())
        .filter(s => s.length > 0)
        .map(s => parseInt(s))
        .filter(n => !isNaN(n));
  }

  die() {
    return this.diceRolls.shift();
  }

  responseIsCorrect() {
    return this.responses.shift() !== 7;
  }
}

class FakeOutput {
  constructor() {
    this.messages = [];
  }

  write(message) {
    this.messages.push(message);
  }

  getOutput() {
    return this.messages.join('\n');
  }
}

describe("Trivia Game with Dependency Injection", function () {

  describe("Deterministic game test with reference data", function () {
    it("should produce the exact same output as the reference result", function () {
      const expectedResult = fs.readFileSync(path.join(__dirname, '../../reference/result.txt'), 'utf8').trim();
      const fakeInput = new FakeFileInput(path.join(__dirname, '../../reference/randomSeq.txt'));
      const fakeOutput = new FakeOutput();

      runGame(fakeInput, fakeOutput);

      const actualResult = fakeOutput.getOutput();
      actualResult.should.equal(expectedResult);
    });
  });
});