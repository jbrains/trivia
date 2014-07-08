#ifndef QUESTION_CATEGORY_H_
#define QUESTION_CATEGORY_H_

#include <stdexcept>
#include <list>

class QuestionCategory
{
public:
    // Constructor that sets the topic.
    QuestionCategory (std::string);

    // Adds a new question to the list.
    void add_question (std::string);

    // Returns the next question and removes it from the list.
    std::string next_question (void) throw (std::runtime_error);

    // Returns the topic
    std::string get_topic (void) const;

private:
    std::string _topic;

    std::list<std::string> _questions;
};

#endif // QUESTION_CATEGORY_H_

