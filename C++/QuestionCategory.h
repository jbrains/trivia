#ifndef QUESTION_CATEGORY_H_
#define QUESTION_CATEGORY_H_

#include <stdexcept>
#include <list>

// Class for storing the questions of a category.
class QuestionCategory
{
public:
    // Constructor that sets the topic.
    QuestionCategory (std::string);

    // Adds a new question to the list.
    virtual void add_question (std::string);

    // Returns the next question and removes it from the list.
    virtual std::string next_question (void) throw (std::runtime_error);

    // Returns the topic
    virtual std::string get_topic (void) const;

private:
    // The topic of the category.
    std::string _topic;

    // List of questions.
    std::list<std::string> _questions;
};

#endif // QUESTION_CATEGORY_H_

