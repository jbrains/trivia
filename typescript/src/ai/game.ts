// Game.ts
export type Logger = (...args: any[]) => void;

export type RollResult = {
  playerIndex: number;
  playerName: string;
  roll: number;
  newLocation: number | null;
  category: string;
  gotOutOfPenaltyBox?: boolean;
  message?: string;
};

export type AnswerResult = {
  playerIndex: number;
  playerName: string;
  correct: boolean;
  coins: number;
  sentToPenaltyBox?: boolean;
  winner: boolean;
  message?: string;
};

type Options = {
  logger?: Logger;
  boardSize?: number;
};

export class Game {
  private players: string[] = [];
  private places: number[] = [];
  private purses: number[] = [];
  private inPenaltyBox: boolean[] = [];
  private currentPlayer: number = 0;

  private boardSize: number;
  private logger: Logger;

  private popQuestions: string[] = [];
  private scienceQuestions: string[] = [];
  private sportsQuestions: string[] = [];
  private rockQuestions: string[] = [];

  private finished: boolean = false;
  private winner: string | null = null;

  constructor(opts?: Options) {
    this.logger = opts?.logger ?? (() => {});
    this.boardSize = opts?.boardSize ?? 12;

    for (let i = 0; i < 50; i++) {
      this.popQuestions.push(`Pop Question ${i}`);
      this.scienceQuestions.push(`Science Question ${i}`);
      this.sportsQuestions.push(`Sports Question ${i}`);
      this.rockQuestions.push(`Rock Question ${i}`);
    }
  }

  // --- Public API ---

  addPlayer(name: string): number {
    if (this.finished) throw new Error("Game has finished.");
    if (!name) throw new Error("Player name must be provided");

    this.players.push(name);
    this.places.push(0);
    this.purses.push(0);
    this.inPenaltyBox.push(false);

    const playerNumber = this.players.length;
    this.logger(`${name} was added`);
    this.logger(`They are player number ${playerNumber}`);
    return playerNumber;
  }

  get gameWon(): boolean {
    return this.finished;
  }

  get winnerName(): string | null {
    return this.winner;
  }

  get playerNames(): string[] {
    return [...this.players];
  }

  get positions(): number[] {
    return [...this.places];
  }

  get coins(): number[] {
    return [...this.purses];
  }

  get penaltyStatus(): boolean[] {
    return [...this.inPenaltyBox];
  }

  currentPlayerName(): string | null {
    if (this.finished) return null;
    return this.players.length > 0 ? this.players[this.currentPlayer] : null;
  }

  // --- Roll phase ---

  roll(value: number): RollResult {
    if (this.finished) throw new Error("Game is already won.");
    if (this.players.length === 0) throw new Error("No players added");
    if (!Number.isInteger(value) || value < 1 || value > 6) {
      throw new Error("Roll must be an integer 1–6");
    }

    const pi = this.currentPlayer;
    const name = this.players[pi];

    this.logger(`${name} is the current player`);
    this.logger(`They have rolled a ${value}`);

    if (this.inPenaltyBox[pi]) {
      const gotOut = value % 2 === 1;

      if (!gotOut) {
        this.logger(`${name} is not getting out of the penalty box`);
        this.advancePlayer();
        return {
          playerIndex: pi,
          playerName: name,
          roll: value,
          newLocation: null,
          category: this.currentCategory(pi),
          gotOutOfPenaltyBox: false,
        };
      }

      this.logger(`${name} is getting out of the penalty box`);
      this.inPenaltyBox[pi] = false;

      this.places[pi] = (this.places[pi] + value) % this.boardSize;
      const category = this.currentCategory(pi);
      this.logger(`${name}'s new location is ${this.places[pi]}`);
      this.logger(`The category is ${category}`);
      this.logger(this.nextQuestion(category));

      return {
        playerIndex: pi,
        playerName: name,
        roll: value,
        newLocation: this.places[pi],
        category,
        gotOutOfPenaltyBox: true,
      };
    }

    // If not in penalty box
    this.places[pi] = (this.places[pi] + value) % this.boardSize;

    const category = this.currentCategory(pi);
    this.logger(`${name}'s new location is ${this.places[pi]}`);
    this.logger(`The category is ${category}`);
    this.logger(this.nextQuestion(category));

    return {
      playerIndex: pi,
      playerName: name,
      roll: value,
      newLocation: this.places[pi],
      category,
    };
  }

  // --- Answering correctly ---

  answerCorrect(): AnswerResult {
    if (this.finished) throw new Error("Game is already won.");

    const pi = this.currentPlayer;
    const name = this.players[pi];

    if (this.inPenaltyBox[pi]) {
      // Cannot score from inside the penalty box
      this.logger(`Answer was correct but ${name} is still in the penalty box`);
      this.advancePlayer();
      return {
        playerIndex: pi,
        playerName: name,
        correct: false,
        coins: this.purses[pi],
        winner: false,
      };
    }

    this.purses[pi] += 1;
    this.logger("Answer was correct!!!!");
    this.logger(`${name} now has ${this.purses[pi]} Gold Coins.`);

    const winner = this.purses[pi] >= 6;

    if (winner) {
      this.finished = true;
      this.winner = name;
      return {
        playerIndex: pi,
        playerName: name,
        correct: true,
        coins: this.purses[pi],
        winner: true,
      };
    }

    this.advancePlayer();
    return {
      playerIndex: pi,
      playerName: name,
      correct: true,
      coins: this.purses[pi],
      winner: false,
    };
  }

  // --- Answering incorrectly ---

  answerIncorrect(): AnswerResult {
    if (this.finished) throw new Error("Game is already won.");

    const pi = this.currentPlayer;
    const name = this.players[pi];

    this.logger("Question was incorrectly answered");
    this.inPenaltyBox[pi] = true;
    this.logger(`${name} was sent to the penalty box`);

    this.advancePlayer();

    return {
      playerIndex: pi,
      playerName: name,
      correct: false,
      coins: this.purses[pi],
      winner: false,
      sentToPenaltyBox: true,
    };
  }

  // --- Helpers ---

  private advancePlayer() {
    this.currentPlayer = (this.currentPlayer + 1) % this.players.length;
  }

  private currentCategory(playerIndex: number): string {
    const loc = this.places[playerIndex];
    switch (loc % 4) {
      case 0:
        return "Pop";
      case 1:
        return "Science";
      case 2:
        return "Sports";
      default:
        return "Rock";
    }
  }

  private nextQuestion(category: string): string {
    switch (category) {
      case "Pop":
        return this.popQuestions.shift() ?? "No Pop Question";
      case "Science":
        return this.scienceQuestions.shift() ?? "No Science Question";
      case "Sports":
        return this.sportsQuestions.shift() ?? "No Sports Question";
      case "Rock":
        return this.rockQuestions.shift() ?? "No Rock Question";
      default:
        return "No Question";
    }
  }
}
