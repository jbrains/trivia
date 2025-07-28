require('./game.js');
var fs = require('fs');
var path = require('path');

function FakeOutput() {
  this.messages = [];
  
  this.write = function(message) {
    this.messages.push(message);
  };

  this.actualMessages = function() {
    return this.messages.join('\n');
  };
}

FakeOutput.expectedMessages = function() {
  return fs.readFileSync(path.join(__dirname, '../reference/result.txt'), 'utf-8').trim();
};

function FakeFileInput() {
  var lines = fs.readFileSync(path.join(__dirname, '../reference/randomSeq.txt'), 'utf-8').trim().split('\n');
  this.responses = this.parseLine(lines[1]);
  this.rolls = this.parseLine(lines[4]);

  this.die = function() {
    return this.rolls.shift();
  };

  this.responseIsCorrect = function() {
    return this.responses.shift() !== 7;
  };

  this.parseLine = function(line) {
    return line.split(',').map(function(n) {
      return parseInt(n.trim());
    }).filter(function(n) {
      return !isNaN(n);
    });
  };
}

describe("The test environment", function() {
  it("should reproduce reference output", function() {
    var fakeOutput = new FakeOutput();

    new GameRunner(
      new FakeFileInput(),
      fakeOutput
    ).run();

    expect(fakeOutput.actualMessages()).toBe(FakeOutput.expectedMessages());
  });
});
