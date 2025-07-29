using System;

namespace Trivia
{
    public class DefaultOutput : IOutput
    {
        public void Write(string message)
        {
            Console.WriteLine(message);
        }
    }
}