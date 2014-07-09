#include "QuestionCategory.h"

#include <stdexcept>

// Constructor that sets the topic.
QuestionCategory::QuestionCategory (std::string topic) : _topic (topic) {}


// Adds a new question to the list.
void QuestionCategory::add_question (std::string question)
{
    _questions.push_back (question);
}


// Returns the next question and removes it from the list.
std::string QuestionCategory::next_question () throw (std::runtime_error)
{
    std::string question;

    if (! _questions.empty ())
    {
        question = _questions.front();
        _questions.pop_front ();
    }
    else
    {
        // There was no question in the list.
        throw std::runtime_error ("No more questions");
    }

    return question;
}

// Returns the topic
std::string QuestionCategory::get_topic () const
{
    return _topic;
}
