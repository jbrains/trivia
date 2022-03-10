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

        private Player _currentPlayer;
        private bool _isRockSelected;

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

                _isRockSelected = key == ConsoleKey.Y;
                if (_isRockSelected)
                {
                    _technoQuestions.AddLast("Techno Question " + i);
                }
                else
                {
                    _rockQuestions.AddLast("Rock Question " + i);
                }
            }
        }

        /// On vérifie si la partie est possible a lancer
        public static bool IsPlayable(int numberPlayer)
        {
            return numberPlayer is >= 2 and < 7;
        }

        public bool Add(List<string> playersName)
        {
            var success = true;
            foreach(var player in playersName)
            {
                if(success)
                    Add(player);
            }
            return success;
        }

        /// Ajout d'un joueur à la partie
        public void Add(string playerName)
        {
            var id = _players.Count + 1;
            var player = new Player(id, playerName);
            _players.Add(player);

            Console.WriteLine(player.Name + " was added");
            Console.WriteLine("He is player number " + player.Id);
        }

        /// Lance le tour du joueur
        public void Roll(int roll, int maxCases)
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
                    Console.WriteLine(_currentPlayer.Name + " is not getting out of prison yet");
                    return;
                }
                
                Console.WriteLine(_currentPlayer.Name + " is getting out of prison");
                _currentPlayer.WillQuitPrison = false;
            }

            _currentPlayer.Position += roll;
            if (_currentPlayer.Position > maxCases - 1)
                _currentPlayer.Position -= maxCases;

            Console.WriteLine(_currentPlayer.Name + "'s new location is " + _currentPlayer.Position);
            Console.WriteLine("The category is " + _currentPlayer.GetCategory(_isRockSelected));
            AskQuestion(_currentPlayer);
        }

        /// Répond à une question choisi en fonction la catégorie
        private void AskQuestion(Player player)
        {
            switch (player.GetCategory(_isRockSelected))
            {
                case ECategory.Pop:
                    Console.WriteLine(_popQuestions.First());
                    _popQuestions.RemoveFirst();
                    break;
                case ECategory.Science:
                    Console.WriteLine(_scienceQuestions.First());
                    _scienceQuestions.RemoveFirst();
                    break;
                case ECategory.Sport:
                    Console.WriteLine(_sportsQuestions.First());
                    _sportsQuestions.RemoveFirst();
                    break;
                case ECategory.Rock:
                    Console.WriteLine(_rockQuestions.First());
                    _rockQuestions.RemoveFirst();
                    break;
                case ECategory.Techno:
                    Console.WriteLine(_technoQuestions.First());
                    _technoQuestions.RemoveFirst();
                    break;
            }
        }

        /// Retourne vrai si la réponse est bonne
        public bool WasCorrectlyAnswered()
        {
            if (_currentPlayer.IsInPrison)
            {
                if (_currentPlayer.WillQuitPrison)
                {
                    _currentPlayer.IsInPrison = false;
                    Console.WriteLine("Answer was correct!!!!");
                    Console.WriteLine(_currentPlayer.Name + " now has " + ++_currentPlayer.Points + " Gold Coins.");
                    return _currentPlayer.DidWin();
                }
                
                IncrementPlayer();
                return false;
            }

            Console.WriteLine("Answer was correct!!!!");
            Console.WriteLine(_currentPlayer.Name + " now has " + ++_currentPlayer.Points + " Gold Coins.");
            
            IncrementPlayer();
            return _currentPlayer.DidWin();
        }

        /// Retourne vrai si la réponse est fausse 
        public bool WrongAnswer()
        {
            
            Console.WriteLine("Question was incorrectly answered");
            Console.WriteLine(_currentPlayer.Name + " was sent to the prison");
            _currentPlayer.IsInPrison = true;

            IncrementPlayer();
            return false;
        }


        private void IncrementPlayer()
        {
            int currentPlayer = _players.IndexOf(_currentPlayer)+1;
            if (currentPlayer == _players.Count)
                currentPlayer = 0;

            _currentPlayer = _players[currentPlayer];
        }
    }

}
