using System;

namespace Trivia
{
    public class GameRunner
    {
        public static void Main(string[] args)
        {
            var questioner = new Questioner();
            var player1 = new Player(questioner, false, 0, "Chet", 0);
            var player2 = new Player(questioner, false, 0, "Pat", 0);
            var player3 = new Player(questioner, false, 0, "Sue", 0);

            var aGame = new Game();

            aGame.Add(player1, player2, player3);

            try
            {
                aGame.Start();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}