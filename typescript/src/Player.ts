export class Player {
  private _name: string;
  // private _joker: boolean;
  private _gold: number;

  private _alwaysFalseAnswer: boolean;
  private _alwaysGetOutOfPenaltyBox: boolean;
  private _inPenaltyBox : boolean;
  // private _joker_is_use_now: boolean;
  constructor(name: string) {
    this._name = name;
    // this._joker = true;
    // this._joker_is_use_now = false;
    this._gold = 0;
    this._alwaysFalseAnswer = false;
  }

  get name(): string {
    return this._name;
  }

  get alwaysFalseAnswer(): boolean {
    return this._alwaysFalseAnswer;
  }

  set alwaysFalseAnswer(value: boolean) {
    this._alwaysFalseAnswer = value;
  }

  get alwaysGetOutOfPenaltyBox(): boolean {
    return this._alwaysGetOutOfPenaltyBox;
  }

  set alwaysGetOutOfPenaltyBox(value: boolean) {
    this._alwaysGetOutOfPenaltyBox = value;
  }

  get inPenaltyBox(): boolean {
    return this._inPenaltyBox;
  }

  set inPenaltyBox(value: boolean) {
    this._inPenaltyBox = value;
  }

  set name(value: string) {
    this._name = value;
  }

  // get joker(): boolean {
  //   return this._joker;
  // }
  //
  // set joker(value: boolean) {
  //   this._joker = value;
  // }

  get gold(): number {
    return this._gold;
  }

  set gold(value: number) {
    this._gold = value;
  }

  // get joker_is_use_now(): boolean {
  //   return this._joker_is_use_now;
  // }
  //
  // set joker_is_use_now(value: boolean) {
  //   this._joker_is_use_now = value;
  // }
}
