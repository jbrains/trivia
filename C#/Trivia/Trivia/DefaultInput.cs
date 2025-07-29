using System;

namespace Trivia
{
    public class DefaultInput : IInput
    {
        private readonly Random _random = new Random();

        public int Die()
        {
            return _random.Next(5) + 1;
        }

        public bool ResponseIsCorrect()
        {
            return _random.Next(9) != 7;
        }
    }
}