using System.Collections.Generic;
using System.IO;
using System.Linq;
using Xunit;

namespace Trivia.Tests
{
    public class FakeOutput : IOutput
    {
        private readonly List<string> _messages = new List<string>();

        public void Write(string message)
        {
            _messages.Add(message);
        }

        public string ActualMessages()
        {
            return string.Join("\n", _messages);
        }

        public static string ExpectedMessages()
        {
            return File.ReadAllText("../../../../../../reference/result.txt").Trim();
        }
    }

    public class FakeFileInput : IInput
    {
        private readonly Queue<int> _responses;
        private readonly Queue<int> _dice;

        public FakeFileInput()
        {
            var lines = File.ReadAllLines("../../../../../../reference/randomSeq.txt");
            _responses = new Queue<int>(ParseLine(lines[1]));
            _dice = new Queue<int>(ParseLine(lines[4]));
        }

        private static IEnumerable<int> ParseLine(string line)
        {
            return line.Split(',')
                .Select(s => int.TryParse((string)s.Trim(), out var result) ? result : (int?)null)
                .Where(i => i.HasValue)
                .Select(i => i.Value);
        }

        public int Die()
        {
            return _dice.Dequeue();
        }

        public bool ResponseIsCorrect()
        {
            return _responses.Dequeue() != 7;
        }
    }

    public class GameRunnerTest
    {
        [Fact]
        public void ShouldReproduceReferenceOutput()
        {
            var fakeOutput = new FakeOutput();

            new GameRunner(
                new FakeFileInput(),
                fakeOutput
            ).Run();

            Assert.Equal(FakeOutput.ExpectedMessages(), fakeOutput.ActualMessages());
        }
    }
}