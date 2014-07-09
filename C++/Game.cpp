#include "Game.h"
#include "Printer.h"

#include <iostream>
#include <sstream>

#define NUM_OF_QUESTIONS 50
#define MAX_PLACE 12
#define MIN_PLAYER 2
#define MAX_PURSE 6

const std::vector<std::string> Game::category_names =
                                   {"Pop", "Science", "Sports", "Rock"};

Game::Game ()
{
    init_categories ();
    
    Player::set_max_place (MAX_PLACE);
}


void Game::init_categories ()
{
    for (std::vector<std::string>::const_iterator topic = 
            Game::category_names.begin();
         topic != category_names.end();
         ++topic)
    {
        categories.push_back (generate_questions (*topic));
    }
}


QuestionCategory* Game::generate_questions (std::string topic)
{
    QuestionCategory *category = new QuestionCategory (topic);

    for (int i = 0; i < NUM_OF_QUESTIONS; ++i)
    {
        std::ostringstream oss (std::ostringstream::out);

        oss << topic << " Question " << i;

        category->add_question (oss.str ());
    }

    return category;
}


bool Game::is_playable ()
{
    return (players.size () >= MIN_PLAYER);
}


bool Game::add_player (string player_name)
{
    Player *player = new Player (player_name);
    players.push_back (player);

    Printer::new_player_added (player, players.size ());

    current_player = players.begin ();

    return true;
}


void Game::roll (int roll)
{
    Player *player = *current_player;

    Printer::player_rolled (player, roll);

    if ((player->is_in_penalty_box ()) && (roll % 2 == 0))
    {
        Printer::stay_in_penalty (player);
    }
    else
    {
        player->get_from_penalty ();

        player->inc_place (roll);

        int cat = player->get_place () % categories.size ();
        Printer::new_location (player, categories[cat]);

        ask_question ();
    }
}


void Game::ask_question ()
{
    // The index of the category where the question comes from
    const int cat = (*current_player)->get_place () % categories.size ();
    try
    {
        Printer::print_question(categories[cat]->next_question ());
    }
    catch (std::runtime_error err)
    {
        Printer::error (err.what ());
    }
}

bool Game::right_answer ()
{
    Player *player = *current_player;
    bool ret = true;

    if (!player->is_in_penalty_box ())
    {
        player->inc_purse ();

	Printer::correct_answer (player);

        ret = did_player_win ();
    }

    next_player ();

    return ret;
}


bool Game::wrong_answer ()
{
    Player *player = *current_player;

    Printer::incorrect_answer (player);

    player->send_to_penalty ();
    next_player ();

    return true;
}


void Game::next_player ()
{
    ++current_player;

    if (current_player == players.end())
        current_player = players.begin();
}

bool Game::did_player_win ()
{
    return ((*current_player)->get_purse () != MAX_PURSE);
}
