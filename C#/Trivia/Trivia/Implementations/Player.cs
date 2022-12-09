using System;

namespace Trivia
{
	public class Player : IPlayer
	{
        private readonly IQuestioner _questioner;
        private bool _isInPenaltyBox;
        private int _hasInPurse;
        private string _name;
        private int _place;
        private bool _isWinner;

        public Player(IQuestioner questioner, bool isInPenaltyBox, int hasInPurse, string name, int place)
        {
            _questioner = questioner;
            _isInPenaltyBox = isInPenaltyBox;
            _hasInPurse = hasInPurse;
            _name = name;
            _place = place;
        }

        public bool IsWinner => _isWinner;

        public bool IsInPenaltyBox
        {
            get
            {
                return _isInPenaltyBox;
            }
            set
            {
                _isInPenaltyBox = value;
            }
        }

        public int HasInPurse
        {
            get
            {
                return _hasInPurse;
            }
            set
            {
                _hasInPurse = value;
            }
        }

        public string Name => _name;

        public int Place => _place;

        public bool RollDice()
        {
            var rand = new Random();
            int number = rand.Next(9);
            Console.WriteLine(_name + " is the current player");
            Console.WriteLine("They have rolled a " + number);

            findWinnerInPenaltyBox(number);
            if (wasAnswerCorrect(number))
            {
                _isWinner = isWinner(number);
            }
            
            return _isWinner;
        }

        private bool isWinner(int number)
        {
            Console.WriteLine($"{Name} has won with {_hasInPurse} coins and dice number {number} and was in penalty box {_isInPenaltyBox}.");
            return _hasInPurse != 6;
        }

        private void findWinnerInPenaltyBox(int number)
        {
            if (_isInPenaltyBox)
            {
                if (number % 2 != 0)
                {
                    _isInPenaltyBox = false;

                    sumUpPlace(number);
                    _isWinner = isWinner(number);
                }
                else
                {
                    Console.WriteLine("Question was incorrectly answered");
                    Console.WriteLine(Name + " stays in the penalty box");
                }
            }
            else
            {
                sumUpPlace(number);
            }
        }

        private void sumUpPlace(int number)
        {
            _place = _place + number;
            if (_place > 11) _place = _place - 12;

            Console.WriteLine(_name
                    + "'s new location is "
                    + _place);
            _questioner.AskQuestion(_place);
        }

        private bool wasAnswerCorrect(int number)
        {
            if (number == 7)
            {
                Console.WriteLine("Question was incorrectly answered");
                Console.WriteLine(Name + " stays in the penalty box");
                _isInPenaltyBox = true;
                return false;
            }

            _isInPenaltyBox = false;
            Console.WriteLine("Answer was correct!!!!");
            _hasInPurse++;
            Console.WriteLine(Name
                    + " now has "
                    + HasInPurse
            + " Gold Coins.");
            return true;
        }
    }
}

