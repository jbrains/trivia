const Should = require("should");
const Game = require("./game.js");
const fs = require("node:fs");
const { describe } = require("node:test");
const { Category, Question } = require("./core.js");

class Snapshot {
  static get = (output = "output.md", output_test = "output_test.md") => [
    fs.readFileSync(output, { encoding: "utf-8" }),
    fs.readFileSync(output_test, { encoding: "utf-8" }),
  ];
}

// describe("The test environment", function () {
//   it("should pass", function () {
//     true.should.equal(true);
//   });

//   it("should access game", function () {
//     Should(Game).not.equal(undefined);
//   });
// });

describe("Golden Record snapshots", function () {
  it("should match", () => {
    const [expected, actual] = Snapshot.get();

    actual.should.equal(expected);
  });
});

describe("Question", () => {
  it("should properly get stringified", () => {
    const q = (category, id) => new Question(category, id).toString();

    q(Category.Pop, 1).should.equal("Pop Question 1");
    q(Category.Science, 2).should.equal("Science Question 2");
    q(Category.Sports, 3).should.equal("Sports Question 3");
    q(Category.Rock, 4).should.equal("Rock Question 4");
  });
});
