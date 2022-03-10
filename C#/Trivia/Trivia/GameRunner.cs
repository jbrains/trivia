using System;
using System.Collections.Generic;

namespace Trivia
{
    public class GameRunner
    {
        public static void Main(string[] args)
        {
            List<string> players = new List<string>()
            {
                "Chet",
                "Pat",
                "Sue"
            };

            if (Game.IsPlayable(players.Count))
            {
                var board = new Board(40);
                var aGame = new Game();
                aGame.Add(players);

                var rand = new Random();
                var isWinner = false;
                do
                {
                    aGame.Roll(rand.Next(5) + 1, board.cases);
                    if (rand.Next(9) == 7)
                    {
                        isWinner = aGame.WrongAnswer();
                    }
                    else
                    {
                        isWinner = aGame.WasCorrectlyAnswered();
                    }
                } while (!isWinner);
            }
            else
            {
                Console.WriteLine("This trivia only supports a minimum of 2 and up to 6 players");
            }
        }
    }
}