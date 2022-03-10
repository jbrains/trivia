using System;
using System.Collections.Generic;

namespace Trivia
{
    public class GameRunner
    {
        private static bool _hasWinner;

        public static void Main(string[] args)
        {
            var players = new List<string> { "Chet", "Pat", "Sue" };
            if (Game.IsPlayable(players.Count))
            {
                Console.WriteLine("Choose a maximum score (default 6)");
                var maxScore = Console.ReadLine();
                int value;

                while (!int.TryParse(maxScore, out value) && !string.IsNullOrWhiteSpace(maxScore))
                {
                    Console.WriteLine("Only number accepted please");
                    maxScore = Console.ReadLine();
                }

                var board = new Board(12);
                var aGame = new Game(maxScore == string.Empty ? 0 : value);
                aGame.Add(players);

                aGame.Play(true);
				aGame.stat();
            }
            else
            {
                Console.WriteLine("This trivia only supports a minimum of 2 and up to 6 players");
            }
        }
    }
}
