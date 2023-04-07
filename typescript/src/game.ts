import { Player } from "./Player";
import { IConsole } from "./IConsole";

export class Game {
  private _players: Array<Player> = [];
  private places: Array<number> = [];
  private purses: Array<number> = [];
  private _currentPlayer: number = 0;

  private popQuestions: Array<string> = [];
  private scienceQuestions: Array<string> = [];
  private sportsQuestions: Array<string> = [];
  private rockOrTechnoQuestions: Array<string> = [];
  private _console: IConsole;

  get console(): IConsole {
    return this._console;
  }


  get players(): Array<Player> {
    return this._players;
  }

  get currentPlayer(): number {
    return this._currentPlayer;
  }

  constructor(console: IConsole, players: Array<Player>, techno: boolean) {
    this._console = console;
    for (const player of players) {
      this.add(player);
    }
    for (let i = 0; i < 50; i++) {
      this.popQuestions.push("Pop Question " + i);
      this.scienceQuestions.push("Science Question " + i);
      this.sportsQuestions.push("Sports Question " + i);
        this.rockOrTechnoQuestions.push(this.createRockOrTechnoQuestion(i, techno));
    }
  }

    private createRockOrTechnoQuestion(index: number, techno: boolean): string {
        return(techno ?  "Techno Question " : "Rock Question ") + index ;
    }

  public add(player: Player): boolean {
    this._players.push(player);
    this.places[this.howManyPlayers()] = 0;
    this.purses[this.howManyPlayers()] = 0;

    this._console.WriteLine("---------- Adding Player ----------");
    this._console.WriteLine(player.name + " was added");
    this._console.WriteLine("They are player number " + this._players.length);
    this._console.WriteLine(" ");

    return true;
  }

  private howManyPlayers(): number {
    return this._players.length;
  }

  public isNumberOfPlayerValid() {
    return this.howManyPlayers() >= 2 && this.howManyPlayers() <= 6;
  }

  public roll(roll: number) {

    if (this._players[this._currentPlayer].alwaysGetOutOfPenaltyBox) {
      roll = 3
    }

    this._console.WriteLine(" ");
    this._console.WriteLine("---------- New game round ----------");
    this._console.WriteLine(
      this._players[this._currentPlayer].name + " is the current player"
    );
    this._console.WriteLine("They have rolled a " + roll);

    if (this._players[this._currentPlayer].inPenaltyBox) {
      if (roll % 2 != 0) {
        this._players[this._currentPlayer].inPenaltyBox = false;
        this._console.WriteLine(
          this._players[this._currentPlayer].name +
            " is getting out of the penalty box"
        );
        this.places[this._currentPlayer] =
          this.places[this._currentPlayer] + roll;
        if (this.places[this._currentPlayer] > 11) {
          this.places[this._currentPlayer] =
            this.places[this._currentPlayer] - 12;
        }

        this._console.WriteLine(
          this._players[this._currentPlayer].name +
            "'s new location is " +
            this.places[this._currentPlayer]
        );
        this._console.WriteLine("The category is " + this.currentCategory());
        this.askQuestion();
      } else {
        this._console.WriteLine(
          this._players[this._currentPlayer].name +
            " is not getting out of the penalty box"
        );
        this._players[this._currentPlayer].inPenaltyBox = true
      }
    } else {
      this.places[this._currentPlayer] = this.places[this._currentPlayer] + roll;
      if (this.places[this._currentPlayer] > 11) {
        this.places[this._currentPlayer] = this.places[this._currentPlayer] - 12;
      }

      this._console.WriteLine(
        this._players[this._currentPlayer].name +
          "'s new location is " +
          this.places[this._currentPlayer]
      );
      this._console.WriteLine("The category is " + this.currentCategory());
      this.askQuestion();
    }
  }

  private askQuestion(): void {
    if (this.currentCategory() == "Pop")
      this._console.WriteLine(this.popQuestions.shift()!);
    if (this.currentCategory() == "Science")
      this._console.WriteLine(this.scienceQuestions.shift()!);
    if (this.currentCategory() == "Sports")
      this._console.WriteLine(this.sportsQuestions.shift()!);
    if (this.currentCategory() == "Rock")
        this._console.WriteLine(this.rockOrTechnoQuestions.shift());
  }

  private currentCategory(): string {
    if (this.places[this._currentPlayer] == 0) return "Pop";
    if (this.places[this._currentPlayer] == 4) return "Pop";
    if (this.places[this._currentPlayer] == 8) return "Pop";
    if (this.places[this._currentPlayer] == 1) return "Science";
    if (this.places[this._currentPlayer] == 5) return "Science";
    if (this.places[this._currentPlayer] == 9) return "Science";
    if (this.places[this._currentPlayer] == 2) return "Sports";
    if (this.places[this._currentPlayer] == 6) return "Sports";
    if (this.places[this._currentPlayer] == 10) return "Sports";
    return "Rock";
  }

  private didPlayerWin(): boolean {
    return !(this._players[this._currentPlayer].gold == 6);
  }

  public wrongAnswer(): boolean {
    this._console.WriteLine("Question was incorrectly answered");
    this._console.WriteLine(
      this._players[this._currentPlayer].name + " was sent to the penalty box"
    );
    this._players[this._currentPlayer].inPenaltyBox = true;

    this._currentPlayer += 1;
    if (this._currentPlayer == this._players.length) this._currentPlayer = 0;
    return true;
  }

  public wasCorrectlyAnswered(): boolean {
    if (this._players[this._currentPlayer].inPenaltyBox) {
        this._currentPlayer += 1;
        if (this._currentPlayer == this._players.length) this._currentPlayer = 0;
        return true;
    } else {
      this._console.WriteLine("Answer was corrent!!!!");

      this._players[this._currentPlayer].gold += 1;
      this._console.WriteLine(
        this._players[this._currentPlayer].name +
          " now has " +
          this._players[this._currentPlayer].gold +
          " Gold Coins."
      );

      var winner = this.didPlayerWin();

      this._currentPlayer += 1;
      if (this._currentPlayer == this._players.length) this._currentPlayer = 0;

      return winner;
    }
  }
}
