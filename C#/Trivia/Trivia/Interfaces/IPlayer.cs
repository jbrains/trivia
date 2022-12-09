namespace Trivia
{
    public interface IPlayer
    {
        bool IsWinner { get; }
        bool IsInPenaltyBox { get; set; }
        int HasInPurse { get; set; }
        string Name { get; }
        int Place { get; }
        bool RollDice();
    }
}