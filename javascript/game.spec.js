var app = require("./Game.js");

describe("The test environment", function () {
    it("should pass", function () {
        expect(true).toBe(true);
    });

    it("should access game", function () {
        expect(Game).toBeDefined();
    });
});

describe("Your specs...", function () {
    it("should start the game", function () {
        var game = new Game();
        expect(game).toBeDefined();
        allPlayers.forEach(player => game.add(player));
        Start();
        // expect(game.players).toBeDefined();
    });
    // it("Should acces player 2", function() {
    //   Game.a
    // });
});