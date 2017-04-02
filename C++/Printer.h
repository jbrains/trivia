#ifndef PRINTER_H_
#define PRINTER_H_

#include <string>

class Player;
class QuestionCategory;

// UI class for printing out messages. All prints must be done by this class.
class Printer
{
public:
    // Prints out the new players name and the total number of players.
    static void new_player_added (Player*, int);

    // Prints out the name of the player and the result of roll.
    static void player_rolled (Player*, int);

    // Prints out that the player is still in the penalty box.
    static void stay_in_penalty (Player*);

    // Prints out a given question.
    static void print_question (std::string);

    // Prints out the new location of the player and
    // the category assigned to this location.
    static void new_location (Player*, QuestionCategory*);

    // Emits an error message.
    static void error (std::string);

    // Prints out the Players name and sum of his gold coins.
    static void correct_answer (Player*);

    // Prints out that player is going to the penalty box.
    static void incorrect_answer (Player*);
};

#endif // PRINTER_H_
