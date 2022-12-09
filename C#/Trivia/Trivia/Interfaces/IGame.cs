namespace Trivia
{
    public interface IGame
    {
        bool Add(params IPlayer[] player);
        bool IsPlayable();
        void Start();
    }
}