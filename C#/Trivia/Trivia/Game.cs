using System;
using System.Collections.Generic;
using System.Linq;

namespace Trivia
{
    public class Game
    {
        private readonly List<Player> _players = new();
        
        private readonly LinkedList<string> _popQuestions = new();
        private readonly LinkedList<string> _scienceQuestions = new();
        private readonly LinkedList<string> _sportsQuestions = new();
        private readonly LinkedList<string> _rockQuestions = new();
        private readonly LinkedList<string> _technoQuestions = new();

        private readonly LinkedList<Question> _questionList = new();
        private Player _currentPlayer;
        private readonly bool _isRockSelected;

        public Game()
        {
            Console.WriteLine("Would you like to play with techno questions instead of rock questions ? (Y/N)");
            var key = ConsoleKey.Enter;
            while (key is not (ConsoleKey.Y or ConsoleKey.N))
            {
                key = Console.ReadKey().Key;
                Console.WriteLine();
            }

            List<int> categoryList = Enum.GetValues(typeof(ECategory))
                .Cast<ECategory>()
                .Select(v => (int) v)
                .ToList();
            
            if (key == ConsoleKey.Y)
                categoryList.RemoveAt(3);
            else
            {
                _isRockSelected = true;
                categoryList.RemoveAt(4);
            }
                
            foreach (int category in categoryList)
            {
                for (var i = 0; i < 50; i++)
                {
                    _questionList.AddLast(
                        new Question(
                            i * (1 + category), 
                            category, 
                            "Question " + (i + 1),
                            "Answer " + (i + 1)
                        )
                    );
                }
            }
        }

        /// On vérifie si la partie est possible a lancer
        public static bool IsPlayable(int numberPlayer)
        {
            return numberPlayer is >= 2 and < 7;
        }

        public void Add(List<string> playersName)
        {
            for (var i = 0; i < playersName.Count; i++)
            {
                var player = new Player(i + 1, playersName[i]);
                _players.Add(player);

                Console.WriteLine(player.Name + " was added");
                Console.WriteLine("He is player number " + player.Id);
            }
        }

        /// Lance le tour du joueur
        public void Roll(int roll, int maxCases = 12)
        {
            if (_currentPlayer == null)
                _currentPlayer = _players.FirstOrDefault();

            Console.WriteLine(_currentPlayer.Name + " is the current player");
            Console.WriteLine("He has rolled a " + roll);

            if (_currentPlayer.IsInPrison)
            {
                if (roll % 2 == 0)
                {
                    _currentPlayer.WillQuitPrison = true;
                    Console.WriteLine(_currentPlayer.Name + " is getting out of prison yet");
                    return;
                }

                Console.WriteLine(_currentPlayer.Name + " is not getting out of prison");
                _currentPlayer.WillQuitPrison = false;
            }

            _currentPlayer.Position += roll;
            if (_currentPlayer.Position > maxCases - 1)
                _currentPlayer.Position -= maxCases;

            Console.WriteLine(_currentPlayer.Name + "'s new location is " + _currentPlayer.Position);
            AskQuestion();
        }

        public bool IsWinner(int random)
        {
            switch (random)
            {
                case 8 when !_currentPlayer.IsJokerUsed:
                    Console.WriteLine(_currentPlayer.Name + " is using its joker!");
                    _currentPlayer.IsJokerUsed = true;
                    IncrementPlayer();
                    return false;
                case 7:
                    return WrongAnswer();
                default:
                    return WasCorrectlyAnswered();
            }
        }

        /// Répond à une question choisi en fonction la catégorie
        private void AskQuestion()
        {
            var category = _currentPlayer.GetCategory(_isRockSelected);
            _currentPlayer.LHistorique.Add(category);
            Console.WriteLine("The category is " + category);
            Question findQuestion = _questionList.FirstOrDefault(q => q.category == (int) category && q.answeredBy == 0);
            if (findQuestion == null)
            {
                Console.WriteLine("Not found question");
                return;
            }

            _questionList.Find(findQuestion).Value.answeredBy = _currentPlayer.Id;
            Console.WriteLine(findQuestion.question);
        }

        /// Retourne vrai si la réponse est bonne
        private bool WasCorrectlyAnswered()
        {
            if (_currentPlayer.IsInPrison)
            {
                if (_currentPlayer.WillQuitPrison)
                {
                    _currentPlayer.IsInPrison = false;
                }
            }

            _currentPlayer.Streak++;
            _currentPlayer.Points += _currentPlayer.Streak;

            Console.WriteLine("Answer was correct!!!!");
            Console.WriteLine(_currentPlayer.Name + " now has " + _currentPlayer.Points + " Gold Coins.");

            var hasWinner = _currentPlayer.DidWin();
            IncrementPlayer();
            return hasWinner;
        }

        /// Retourne vrai si la réponse est fausse 
        private bool WrongAnswer()
        {
            _currentPlayer.Streak = 0;

            Console.WriteLine("Question was incorrectly answered");
            Console.WriteLine(_currentPlayer.Name + " was sent to the prison");
            _currentPlayer.IsInPrison = true;

            IncrementPlayer();
            return false;
        }


        private void IncrementPlayer()
        {
            int currentPlayer = _players.IndexOf(_currentPlayer) + 1;
            if (currentPlayer == _players.Count)
                currentPlayer = 0;

            _currentPlayer = _players[currentPlayer];
        }

        public void stat()
        {
            foreach (var player in _players)
            {
                Console.WriteLine(player.Name);
                Console.WriteLine("Rock :" + player.LHistorique.FindAll(delegate (ECategory s) { return s == ECategory.Rock; }).Count());
                Console.WriteLine("Science :" + player.LHistorique.FindAll(delegate (ECategory s) { return s == ECategory.Science; }).Count());
                Console.WriteLine("Pop :" + player.LHistorique.FindAll(delegate (ECategory s) { return s == ECategory.Pop; }).Count());
                Console.WriteLine("Sport :" + player.LHistorique.FindAll(delegate (ECategory s) { return s == ECategory.Sport; }).Count());
                Console.WriteLine("Techno :" + player.LHistorique.FindAll(delegate (ECategory s) { return s == ECategory.Techno; }).Count());
            }

        }
    }

}
