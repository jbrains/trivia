const Should = require("should");
const Game = require("./game.js");
const fs = require("node:fs");

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
