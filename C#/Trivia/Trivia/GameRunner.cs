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
                var board = new Board(12);
                var aGame = new Game();
                aGame.Add(players);

                aGame.Play();
				aGame.stat();
            }
            else
            {
                Console.WriteLine("This trivia only supports a minimum of 2 and up to 6 players");
            }
        }
    }
}
