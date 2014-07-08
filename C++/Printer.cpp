#include "Printer.h"

#include <iostream>


void Printer::new_player_added (Player *player, int n)
{
    std::cout << player->get_name()
              << " was added"
              << std::endl
              << "They are player number "
              << n
              << std::endl;
}


void Printer::player_rolled (Player *player, int roll)
{
    std::cout << player->get_name ()
              << " is the current player"
              << std::endl
              << "They have rolled a "
              << roll
              << std::endl;
}


void Printer::stay_in_penalty (Player* player)
{
    std::cout << player->get_name ()
              << " is not getting out of the penalty box"
              << std::endl;
}


void Printer::print_question (std::string question)
{
    std::cout << question << std::endl;
}


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


void Printer::error (std::string msg)
{
    std::cout << "Error: " << msg << std::endl;
}


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

void Printer::incorrect_answer (Player* player)
{
    std::cout << "Question was incorrectly answered"
              << std::endl
              << player->get_name ()
              << " was sent to the penalty box"
              << std::endl;
}
