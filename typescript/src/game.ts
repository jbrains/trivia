import * as readline from "readline-sync";

interface Player {
    name: string;
    place: number;
    gold: number;
    isInPenaltyBox: boolean;
    isGettingOutOfPenaltyBox: boolean;
}

export const initPlayers = (playerNames: string[]) => {
    const players: Player[] = playerNames.map((playerName) => {
        return {
            name: playerName,
            gold: 0,
            place: 0,
            isInPenaltyBox: false,
            isGettingOutOfPenaltyBox: false,
        };
    });
    return players;
};

export class Game {
    private nplayers: Player[];
    private isRock: boolean;
    private players: Array<string> = [];
    private places: Array<number> = [];
    private purses: Array<number> = [];
    private inPenaltyBox: Array<boolean> = [];
    private currentPlayer: number = 0;
    private isGettingOutOfPenaltyBox: boolean = false;

    private popQuestions: Array<string> = [];
    private scienceQuestions: Array<string> = [];
    private sportsQuestions: Array<string> = [];
    private rockQuestions: Array<string> = [];

    constructor(playerNames: string[]) {
        this.nplayers = initPlayers(playerNames);

        this.askRockType();

        for (let i = 0; i < 50; i++) {
            this.popQuestions.push("Pop Question " + i);
            this.scienceQuestions.push("Science Question " + i);
            this.sportsQuestions.push("Sports Question " + i);
            this.rockQuestions.push(this.createRockQuestion(i, this.isRock));
        }
    }

    private async askRockType() {
        let rockPrompt: string = readline.question("Tu veux du rock mon copain ? (Y/N) : ");

        if (rockPrompt.toLowerCase() === "y") {
            this.isRock = true;
            console.log("You choose Rock");
        } else if (rockPrompt.toLowerCase() === "n") {
            this.isRock = false;
            console.log("You'll have Techno questions");
        } else {
            this.isRock = false;
            console.log("Invalid answer, You'll have Techno questions");
        }
    }

    private createRockQuestion(index: number, isRock: boolean): string {
        let type: string;
        type = isRock ? "Rock" : "Techno";
        return type + " Question " + index;
    }

    public checkPlayers(): boolean {
        if (this.players.length >= 2 && this.players.length <= 6) {
            return true;
        }
        return false;
    }
    public add(name: string): boolean {
        this.players.push(name);
        this.places[this.howManyPlayers()] = 0;
        this.purses[this.howManyPlayers()] = 0;
        this.inPenaltyBox[this.howManyPlayers()] = false;

        console.log(name + " was added");
        console.log("They are player number " + this.players.length);

        return true;
    }

    private howManyPlayers(): number {
        return this.players.length;
    }

    public roll(roll: number) {
        console.log(this.players[this.currentPlayer] + " is the current player");
        console.log("They have rolled a " + roll);

        if (this.inPenaltyBox[this.currentPlayer]) {
            if (roll % 2 != 0) {
                this.isGettingOutOfPenaltyBox = true;

                console.log(this.players[this.currentPlayer] + " is getting out of the penalty box");
                this.places[this.currentPlayer] = this.places[this.currentPlayer] + roll;
                if (this.places[this.currentPlayer] > 11) {
                    this.places[this.currentPlayer] = this.places[this.currentPlayer] - 12;
                }

                console.log(this.players[this.currentPlayer] + "'s new location is " + this.places[this.currentPlayer]);
                console.log("The category is " + this.currentCategory());
                this.askQuestion();
            } else {
                console.log(this.players[this.currentPlayer] + " is not getting out of the penalty box");
                this.isGettingOutOfPenaltyBox = false;
            }
        } else {
            this.places[this.currentPlayer] = this.places[this.currentPlayer] + roll;
            if (this.places[this.currentPlayer] > 11) {
                this.places[this.currentPlayer] = this.places[this.currentPlayer] - 12;
            }

            console.log(this.players[this.currentPlayer] + "'s new location is " + this.places[this.currentPlayer]);
            console.log("The category is " + this.currentCategory());
            this.askQuestion();
        }
    }

    private askQuestion(): void {
        if (this.currentCategory() == "Pop") console.log(this.popQuestions.shift());
        if (this.currentCategory() == "Science") console.log(this.scienceQuestions.shift());
        if (this.currentCategory() == "Sports") console.log(this.sportsQuestions.shift());
        if (this.currentCategory() == "Rock") console.log(this.rockQuestions.shift());
    }

    private currentCategory(): string {
        if (this.places[this.currentPlayer] == 0) return "Pop";
        if (this.places[this.currentPlayer] == 4) return "Pop";
        if (this.places[this.currentPlayer] == 8) return "Pop";
        if (this.places[this.currentPlayer] == 1) return "Science";
        if (this.places[this.currentPlayer] == 5) return "Science";
        if (this.places[this.currentPlayer] == 9) return "Science";
        if (this.places[this.currentPlayer] == 2) return "Sports";
        if (this.places[this.currentPlayer] == 6) return "Sports";
        if (this.places[this.currentPlayer] == 10) return "Sports";
        return "Rock";
    }

    private didPlayerWin(): boolean {
        return !(this.purses[this.currentPlayer] == 6);
    }

    public wrongAnswer(): boolean {
        console.log("Question was incorrectly answered");
        console.log(this.players[this.currentPlayer] + " was sent to the penalty box");
        this.inPenaltyBox[this.currentPlayer] = true;

        this.currentPlayer += 1;
        if (this.currentPlayer == this.players.length) this.currentPlayer = 0;
        return true;
    }

    public wasCorrectlyAnswered(): boolean {
        if (this.inPenaltyBox[this.currentPlayer]) {
            if (this.isGettingOutOfPenaltyBox) {
                console.log("Answer was correct!!!!");
                this.purses[this.currentPlayer] += 1;
                console.log(
                    this.players[this.currentPlayer] + " now 1has " + this.purses[this.currentPlayer] + " Gold Coins."
                );

                var winner = this.didPlayerWin();
                this.currentPlayer += 1;
                if (this.currentPlayer == this.players.length) this.currentPlayer = 0;

                return winner;
            } else {
                this.currentPlayer += 1;
                if (this.currentPlayer == this.players.length) this.currentPlayer = 0;
                return true;
            }
        } else {
            console.log("Answer was corrent!!!!");

            this.purses[this.currentPlayer] += 1;
            console.log(
                this.players[this.currentPlayer] + " now 2has " + this.purses[this.currentPlayer] + " Gold Coins."
            );

            var winner = this.didPlayerWin();

            this.currentPlayer += 1;
            if (this.currentPlayer == this.players.length) this.currentPlayer = 0;

            return winner;
        }
    }
}
