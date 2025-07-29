using System;

namespace Trivia
{
    public class GameRunner
    {
        private bool _notAWinner;
        private readonly IInput _input;
        private readonly IOutput _output;
        
        public GameRunner(IInput input, IOutput output)
        {
            _input = input;
            _output = output;
        }

        public static void Main(string[] args)
        {
            new GameRunner(new DefaultInput(), new DefaultOutput()).Run();
        }

        public void Run()
        {
            var aGame = new Game(_output);

            aGame.Add("Chet");
            aGame.Add("Pat");
            aGame.Add("Sue");

            do
            {
                aGame.Roll(_input.Die());

                if (!_input.ResponseIsCorrect())
                {
                    _notAWinner = aGame.WrongAnswer();
                }
                else
                {
                    _notAWinner = aGame.WasCorrectlyAnswered();
                }
            } while (_notAWinner);
        }
    }
}