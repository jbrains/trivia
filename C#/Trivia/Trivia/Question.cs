namespace Trivia {
    public class Question
    {

        public int id;
        public int category;
        public string question;
        public string answer;
        public int answeredBy;

        public Question(int id, int category, string question, string answer)
        {
            this.id = id;
            this.category = category;
            this.question = question;
            this.answer = answer;
        }
    }
}