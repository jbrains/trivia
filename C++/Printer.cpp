#include "Printer.h"
#include "Player.h"
#include "QuestionCategory.h"

#include <iostream>

// Prints out the new players name and the total number of players.
void Printer::new_player_added (Player *player, int n)
{
    std::cout << player->get_name()
              << " was added"
              << std::endl
              << "They are player number "
              << n
              << std::endl;
}


// Prints out the name of the player and the result of roll.
void Printer::player_rolled (Player *player, int roll)
{
    std::cout << player->get_name ()
              << " is the current player"
              << std::endl
              << "They have rolled a "
              << roll
              << std::endl;
}


// Prints out that the player is still in the penalty box.
void Printer::stay_in_penalty (Player* player)
{
    std::cout << player->get_name ()
              << " is not getting out of the penalty box"
              << std::endl;
}


// Prints out a given question.
void Printer::print_question (std::string question)
{
    std::cout << question << std::endl;
}


// Prints out the new location of the player and
// the category assigned to this location.
void Printer::new_location (Player* player, QuestionCategory* category)
{
    std::cout << player->get_name ()
              << "'s new location is "
              << player->get_place ()
              << std::endl
              << "The category is "
              << category->get_topic ()
              << std::endl;
}


// Emits an error message.
void Printer::error (std::string msg)
{
    std::cout << "Error: " << msg << std::endl;
}


// Prints out the Players name and sum of his gold coins.
void Printer::correct_answer (Player* player)
{
    std::cout << "Answer was correct!!!!"
              << std::endl
              << player->get_name ()
              << " now has "
              << player->get_purse ()
              << " Gold Coins."
              << std::endl;
}


// Prints out that player is going to the penalty box.
void Printer::incorrect_answer (Player* player)
{
    std::cout << "Question was incorrectly answered"
              << std::endl
              << player->get_name ()
              << " was sent to the penalty box"
              << std::endl;
}
