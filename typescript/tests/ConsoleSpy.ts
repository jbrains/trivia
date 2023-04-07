import {IConsole} from "../src/IConsole";

export class ConsoleSpy implements IConsole {
    private _output: string = "";

    public get Content(): string {
        return this._output;
    }

    public WriteLine(message: string): void {
        this._output += message + "\n";
    }
}