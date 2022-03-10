﻿namespace Trivia
{
    public class Player
    {
        public int Id { get; }
        public string Name { get; }
        public int Points { get; set; }
        public int Position { get; set; }
        public bool IsInPrison { get; set; }
        public bool WillQuitPrison { get; set; }
        public bool IsJokerUsed { get; set; }
        public int Streak { get; set; }

        public Player(int id, string name)
        {
            Id = id;
            Name = name;
            Points = 0;
            Position = 0;
            IsInPrison = false;
            WillQuitPrison = false;
            IsJokerUsed = false;
        }

        public ECategory GetCategory(bool techno)
        {
            switch (Position)
            {
                case 0:
                case 4:
                case 8:
                    return ECategory.Pop;
                case 1:
                case 5:
                case 9:
                    return ECategory.Science;
                case 2:
                case 6:
                case 10:
                    return ECategory.Sport;
                default:
                    return techno ? ECategory.Techno : ECategory.Rock;
            }
        }

        public bool DidWin() => Points == 6;

        public override string ToString() => $"{Name} has {Points} points";
    }
}