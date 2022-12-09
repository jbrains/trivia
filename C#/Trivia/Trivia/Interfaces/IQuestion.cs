namespace Trivia
{
    public interface IQuestion
    {
        string MyQuestion { get; }
        Category Category { get; }
    }
}