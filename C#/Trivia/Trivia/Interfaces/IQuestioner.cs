namespace Trivia
{
    public interface IQuestioner
    {
        int Place { get; }

        void AskQuestion(int place);
    }
}