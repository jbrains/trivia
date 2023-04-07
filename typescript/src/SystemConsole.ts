import {IConsole} from "./IConsole";

export class SystemConsole implements IConsole {
    public WriteLine(message: string): void
    {
        console.log(message);
    }
}