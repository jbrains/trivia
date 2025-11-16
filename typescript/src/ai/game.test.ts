require("seedrandom")("42", { global: true });

import { describe, expect, it } from "vitest";
import fs from "node:fs";
import { GameRunner } from "./game-runner";
import { Game } from "./game";

class Snapshot {
  static get = (output = "output.md", output_test = "output_test.md") => [
    fs.readFileSync(output, { encoding: "utf-8" }),
    fs.readFileSync(output_test, { encoding: "utf-8" }),
  ];
}

describe("Golden Record snapshots", () => {
  it("should match", () => {
    const [expected, actual] = Snapshot.get();

    expect(actual).toBe(expected);
  });
});

// describe("player 1 is always NaN", () => {
//   it("should match", () => {
//     const game = new Game();
//     game.coins[0];
//     // expect(actual).toBe(expected);
//   });
// });
