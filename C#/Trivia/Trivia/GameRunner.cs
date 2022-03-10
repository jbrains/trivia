using System;

namespace Trivia
{
    public class GameRunner
    {
        public static void Main(string[] args)
        {
            var aGame = new Game();
            aGame.Add("Chet");
            aGame.Add("Pat");
            aGame.Add("Sue");

            if (aGame.IsPlayable())
            {
                var rand = new Random();
                var isWinner = false;
                do
                {
                    aGame.Roll(rand.Next(5) + 1);
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