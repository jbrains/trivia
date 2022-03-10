import { Game } from "./game";
import {
    checkPlayers,
    roll,
    switchPlayer,
    wasCorrectlyAnswered,
    wrongAnswer,
} from "./utils";
import * as readline from "readline-sync";

export class GameRunner {
    public static main(): void {
        let maxGold: number = readline.question(
            "Maximum gold wished ? (6 min) "
        );
        if (maxGold < 6) {
            console.log("Error : you cannot have less than 6 gold, maximum gold are set to 6");
            maxGold = 6;
        }
        const game = new Game(["Chet", "Pat", "Sue"], maxGold);

        const isGameValid = checkPlayers(game.players);
        if (!isGameValid) {
            console.error("Game should have more than 2 and less than 7 players");
            return;
        }
        let gameHasEnded = false;
        do {
            const diceRoll = Math.floor(Math.random() * 6) + 1;
            let action = roll(
                game.players,
                game.currentPlayer,
                game.questions,
                game.isRock,
                diceRoll,
                game.rageQuitBoard
            );

            if (action != 2) {
                if (Math.floor(Math.random() * 10) == 7) {
                    wrongAnswer(game.players, game.currentPlayer);
                } else {
                    let winner = wasCorrectlyAnswered(
                        game.players,
                        game.currentPlayer,
                        game.maxGold
                    );
                    if (winner) {
                        game.leaderboard.push(game.players[game.currentPlayer]);
                        game.players[game.currentPlayer].hasQuit = true;
                    } 
                    if (game.leaderboard.length === (game.players.length - game.rageQuitBoard.length)) gameHasEnded = true;
                }
            } else {
                console.log(
                    "🃏" + game.players[game.currentPlayer].name + " used a joker"
                );
            }
            game.currentPlayer = switchPlayer(game.currentPlayer, game.players);
        } while (!gameHasEnded);
        game.rageQuitBoard.reverse();
        game.rageQuitBoard.forEach(element => {
            game.leaderboard.push(element);
        })
        let i = 1;
        console.log("LeaderBoard: \ ");
        game.leaderboard.forEach(element => {
            console.log(i + " - " + element.name + " \ ");
            i++;
        })
    }
}

GameRunner.main();
