export interface Output {
    write(message: string): void;
}

export class ConsoleOutput implements Output {
    write(message: string): void {
        console.log(message);
    }
}