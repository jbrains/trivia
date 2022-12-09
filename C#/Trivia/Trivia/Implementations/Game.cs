using System;
using System.Collections.Generic;

namespace Trivia
{
    public class Game : IGame
    {
        private readonly List<IPlayer> _players;

        private IPlayer _currentPlayer;
        int _playerNumber = 0;

        public Game()
        {
            _players = new List<IPlayer>();
        }

        public void Start()
        {
            var winner = false;

            do
            {
                foreach (var player in _players)
                {
                    winner = player.RollDice();
                    if (winner)
                        break;
                }
            } while (!winner);
        }

        public bool IsPlayable()
        {
            return (_players.Count >= 2);
        }

        public bool Add(params IPlayer[] player)
        {
            for (int i = 0; i < player.Length; ++i)
            {
                _players.Add(player[i]);

                Console.WriteLine(player[i].Name + " was added");
                Console.WriteLine("They are player number " + _players.Count);
            }
            return true;
        }
    }

}
