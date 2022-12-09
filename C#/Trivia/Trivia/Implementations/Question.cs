namespace Trivia
{
    public class Question : IQuestion
    {
        private readonly Category _category;
        private readonly string _question;

        public string MyQuestion => _question;
        public Category Category => _category;

        public Question(Category category, string question)
        {
            this._category = category;
            this._question = question;
        }
    }
}

