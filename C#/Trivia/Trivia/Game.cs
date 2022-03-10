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

        private int _currentPlayer;
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
        public bool IsPlayable()
        {
            var count = _players.Count;
            return count is >= 2 and < 7;
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
        public void Roll(int roll)
        {
            var player = _players[_currentPlayer];
            Console.WriteLine(player.Name + " is the current player");
            Console.WriteLine("He has rolled a " + roll);

            if (player.IsInPrison)
            {
                if (roll % 2 == 0)
                {
                    player.WillQuitPrison = true;
                    Console.WriteLine(player.Name + " is not getting out of prison yet");
                    return;
                }
                
                Console.WriteLine(player.Name + " is getting out of prison");
                player.WillQuitPrison = false;
            }
            
            player.Position += roll;
            if (player.Position > 11)
                player.Position -= 12;

            Console.WriteLine(player.Name + "'s new location is " + player.Position);
            Console.WriteLine("The category is " + player.GetCategory(_isRockSelected));
            AskQuestion(player);
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
            var player = _players[_currentPlayer];
            if (player.IsInPrison)
            {
                if (player.WillQuitPrison)
                {
                    player.IsInPrison = false;
                    Console.WriteLine("Answer was correct!!!!");
                    Console.WriteLine(player.Name + " now has " + ++player.Points + " Gold Coins.");
                    return player.DidWin();
                }
                
                IncrementPlayer();
                return false;
            }

            Console.WriteLine("Answer was correct!!!!");
            Console.WriteLine(player.Name + " now has " + ++player.Points + " Gold Coins.");
            
            IncrementPlayer();
            return player.DidWin();
        }

        /// Retourne vrai si la réponse est fausse 
        public bool WrongAnswer()
        {
            var player = _players[_currentPlayer];
            
            Console.WriteLine("Question was incorrectly answered");
            Console.WriteLine(player.Name + " was sent to the prison");
            player.IsInPrison = true;

            IncrementPlayer();
            return false;
        }


        private void IncrementPlayer()
        {
            _currentPlayer++;
            if (_currentPlayer == _players.Count - 1)
                _currentPlayer = 0;
        }
    }

}
