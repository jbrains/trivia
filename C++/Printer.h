#ifndef PRINTER_H_
#define PRINTER_H_

#include <string>

class Player;
class QuestionCategory;

class Printer
{
public:
    static void new_player_added (Player*, int);

    static void player_rolled (Player*, int);

    static void stay_in_penalty (Player*);

    static void print_question (std::string);

    static void new_location (Player*, QuestionCategory*);

    static void error (std::string);

    static void correct_answer (Player*);

    static void incorrect_answer (Player*);
};

#endif // PRINTER_H_
