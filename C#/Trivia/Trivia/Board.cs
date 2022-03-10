using System;
namespace Trivia
{
    public class Board
    {
        int id;
        public int cases { get; }

        public Board(int cases)
        {
            Console.WriteLine("Ajout d'un plateau de {0} cases", cases);
            id = 1;
            this.cases = cases;
        }
    }
}

