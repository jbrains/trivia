import firebase from "firebase/compat";

export class User {
  id: string;
  name: string;
  isAnonymous: boolean

  constructor(id: string, name: string, isAnonymous: boolean) {
    this.id = id;
    this.name = name;
    this.isAnonymous = isAnonymous;
  }
}

export class Nobody extends User {
  private static _instance: Nobody = new Nobody();

  constructor() {
    super("", "", true);
  }

  static get instance(): Nobody {
    return this._instance;
  }
}
