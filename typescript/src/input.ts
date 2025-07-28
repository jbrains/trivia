export interface Input {
    die(): number;
    responseIsCorrect() :boolean
}

export class RandomInput implements Input {
    die(): number {
        return Math.floor(Math.random() * 6) + 1;
    }

    responseIsCorrect() :boolean {
        return Math.floor(Math.random() * 10) !== 7
    }
}