using System;
using System.Collections.Generic;
using System.Linq;

namespace Trivia
{
    public class Game
    {
        private readonly List<string> _players = new();

        private readonly int[] _places = new int[6];
        private readonly int[] _purses = new int[6];

        private readonly bool[] _inPenaltyBox = new bool[6];

        private readonly LinkedList<string> _popQuestions = new();
        private readonly LinkedList<string> _scienceQuestions = new();
        private readonly LinkedList<string> _sportsQuestions = new();
        private readonly LinkedList<string> _rockQuestions = new();
        private readonly LinkedList<string> _technoQuestions = new();

        private int _currentPlayer;
        private bool _isGettingOutOfPenaltyBox;
        private bool _isRockSelected;

        enum Category
        {
            Pop,
            Science,
            Sport,
            Rock,
            Techno
        }

        public Game()
        {
            Console.WriteLine("Would you like to play with techno questions instead of rock questions ? (Y/N)");
            ConsoleKey key = ConsoleKey.Enter;
            while (!(key == ConsoleKey.Y || key == ConsoleKey.N))
            {
                key = Console.ReadKey().Key;
                Console.WriteLine();
            }

            for (var i = 0; i < 50; i++)
            {
                _popQuestions.AddLast("Pop Question " + i);
                _scienceQuestions.AddLast("Science Question " + i);
                _sportsQuestions.AddLast("Sports Question " + i);

                if (key == ConsoleKey.Y)
                    _technoQuestions.AddLast("Techno Question " + i);
                else
                {
                    _isRockSelected = true;
                    _rockQuestions.AddLast("Rock Question " + i);
                }
            }
        }

        public bool IsPlayable()
        {
            var count = _players.Count;
            return count is >= 2 and < 7;
        }

        public bool Add(string playerName)
        {
            _players.Add(playerName);
            _places[_players.Count] = 0;
            _purses[_players.Count] = 0;
            _inPenaltyBox[_players.Count] = false;

            Console.WriteLine(playerName + " was added");
            Console.WriteLine("He is player number " + _players.Count);
            return true;
        }

        public void Roll(int roll)
        {
            Console.WriteLine(_players[_currentPlayer] + " is the current player");
            Console.WriteLine("He has rolled a " + roll);

            if (_inPenaltyBox[_currentPlayer])
            {
                if (roll % 2 != 0)
                {
                    _isGettingOutOfPenaltyBox = true;

                    Console.WriteLine(_players[_currentPlayer] + " is getting out of the penalty box");
                    _places[_currentPlayer] += roll;
                    if (_places[_currentPlayer] > 11) _places[_currentPlayer] -= 12;

                    Console.WriteLine(_players[_currentPlayer]
                            + "'s new location is "
                            + _places[_currentPlayer]);
                    Console.WriteLine("The category is " + CurrentCategory());
                    AskQuestion();
                }
                else
                {
                    Console.WriteLine(_players[_currentPlayer] + " is not getting out of the penalty box");
                    _isGettingOutOfPenaltyBox = false;
                }
            }
            else
            {
                _places[_currentPlayer] += roll;
                if (_places[_currentPlayer] > 11) _places[_currentPlayer] -= 12;

                Console.WriteLine(_players[_currentPlayer]
                        + "'s new location is "
                        + _places[_currentPlayer]);
                Console.WriteLine("The category is " + CurrentCategory());
                AskQuestion();
            }
        }

        private void AskQuestion()
        {
            var category = CurrentCategory();
            switch (category)
            {
                case Category.Pop:
                    Console.WriteLine(_popQuestions.First());
                    _popQuestions.RemoveFirst();
                    break;
                case Category.Science:
                    Console.WriteLine(_scienceQuestions.First());
                    _scienceQuestions.RemoveFirst();
                    break;
                case Category.Sport:
                    Console.WriteLine(_sportsQuestions.First());
                    _sportsQuestions.RemoveFirst();
                    break;
                case Category.Rock:
                    Console.WriteLine(_rockQuestions.First());
                    _rockQuestions.RemoveFirst();
                    break;
                case Category.Techno:
                    Console.WriteLine(_technoQuestions.First());
                    _technoQuestions.RemoveFirst();
                    break;
            }
        }

        private Category CurrentCategory()
        {
            switch (_places[_currentPlayer])
            {
                case 0:
                case 4:
                case 8:
                    return Category.Pop;
                case 1:
                case 5:
                case 9:
                    return Category.Science;
                case 2:
                case 6:
                case 10:
                    return Category.Sport;
                default:
                    return _isRockSelected ? Category.Rock : Category.Techno;
            }
        }

        public bool WasCorrectlyAnswered()
        {
            if (_inPenaltyBox[_currentPlayer])
            {
                if (_isGettingOutOfPenaltyBox)
                {
                    Console.WriteLine("Answer was correct!!!!");
                    _purses[_currentPlayer]++;
                    Console.WriteLine(_players[_currentPlayer]
                            + " now has "
                            + _purses[_currentPlayer]
                            + " Gold Coins.");

                    var winner = DidPlayerWin();
                    _currentPlayer++;
                    if (_currentPlayer == _players.Count) _currentPlayer = 0;

                    return winner;
                }
                else
                {
                    _currentPlayer++;
                    if (_currentPlayer == _players.Count) _currentPlayer = 0;
                    return true;
                }
            }
            else
            {
                Console.WriteLine("Answer was correct!!!!");
                _purses[_currentPlayer]++;
                Console.WriteLine(_players[_currentPlayer]
                        + " now has "
                        + _purses[_currentPlayer]
                        + " Gold Coins.");

                var winner = DidPlayerWin();
                _currentPlayer++;
                if (_currentPlayer == _players.Count) _currentPlayer = 0;

                return winner;
            }
        }

        public bool WrongAnswer()
        {
            Console.WriteLine("Question was incorrectly answered");
            Console.WriteLine(_players[_currentPlayer] + " was sent to the penalty box");
            _inPenaltyBox[_currentPlayer] = true;

            _currentPlayer++;
            if (_currentPlayer == _players.Count) _currentPlayer = 0;
            return true;
        }


        private bool DidPlayerWin()
        {
            return _purses[_currentPlayer] != 6;
        }
    }

}
