using System;
using System.Collections.Generic;
using System.Linq;

namespace Trivia
{
    public class Questioner : IQuestioner
    {
        private readonly LinkedList<Question> _popQuestions;
        private readonly LinkedList<Question> _scienceQuestions;
        private readonly LinkedList<Question> _sportsQuestions;
        private readonly LinkedList<Question> _rockQuestions;

        private int _place;

        public int Place
        {
            get { return _place; }
        }

        public Questioner()
        {
            _popQuestions = new LinkedList<Question>();
            _scienceQuestions = new LinkedList<Question>();
            _sportsQuestions = new LinkedList<Question>();
            _rockQuestions = new LinkedList<Question>();

            createQuestions();
        }

        public void AskQuestion(int place)
        {
            try
            {
                _place = place;
                var category = CurrentCategory();
                Question question = null;

                Console.WriteLine("The category is " + category);

                switch (category)
                {
                    case Category.Pop:
                        {
                            if (_popQuestions.Any())
                                question = _popQuestions.First();
                            else
                                createQuestions();
                            Console.WriteLine(question.MyQuestion);
                            _popQuestions.RemoveFirst();
                            break;
                        }
                    case Category.Science:
                        {
                            if (_scienceQuestions.Any())
                                question = _scienceQuestions.First();
                            else
                                createQuestions();
                            Console.WriteLine(question.MyQuestion);

                            _scienceQuestions.RemoveFirst();
                            break;
                        }
                    case Category.Sports:
                        {
                            if (_sportsQuestions.Any())
                                question = _sportsQuestions.First();
                            else
                                createQuestions();
                            Console.WriteLine(question.MyQuestion);

                            _sportsQuestions.RemoveFirst();
                            break;
                        }
                    case Category.Rock:
                        {
                            if (_rockQuestions.Any())
                                question = _rockQuestions.First();
                            else
                                createQuestions();
                            Console.WriteLine(question.MyQuestion);

                            _rockQuestions.RemoveFirst();
                            break;
                        }
                    default:
                        throw new NotSupportedException(nameof(category));

                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        Category CurrentCategory()
        {
            if (_place == 0) return Category.Pop;
            if (_place == 4) return Category.Pop;
            if (_place == 8) return Category.Pop;
            if (_place == 1) return Category.Science;
            if (_place == 5) return Category.Science;
            if (_place == 9) return Category.Science;
            if (_place == 2) return Category.Sports;
            if (_place == 6) return Category.Sports;
            if (_place == 10) return Category.Sports;
            return Category.Rock;
        }

        private void createQuestions()
        {
            for (var i = 0; i < 50; i++)
            {
                _popQuestions.AddLast(new Question(Category.Pop, "Pop Question " + i));
                _scienceQuestions.AddLast(new Question(Category.Science, "Science Question " + i));
                _sportsQuestions.AddLast(new Question(Category.Sports, "Sports Question " + i));
                _rockQuestions.AddLast(new Question(Category.Rock, "Rock Question " + i));
            }
        }
    }
}

