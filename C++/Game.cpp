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


bool Game::isPlayable ()
{
    return (players.size () >= MIN_PLAYER);
}


bool Game::add (string playerName)
{
    Player *player = new Player (playerName);
    players.push_back (player);

    Printer::new_player_added (player, players.size ());

    currentPlayer = players.begin ();

    return true;
}


void Game::roll (int roll)
{
    Player *player = *currentPlayer;

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

        askQuestion ();
    }
}


void Game::askQuestion ()
{
    // The index of the category where the question comes from
    const int cat = (*currentPlayer)->get_place () % categories.size ();
    try
    {
        Printer::print_question(categories[cat]->next_question ());
    }
    catch (std::runtime_error err)
    {
        Printer::error (err.what ());
    }
}

bool Game::wasCorrectlyAnswered ()
{
    Player *player = *currentPlayer;
    bool ret = true;

    if (!player->is_in_penalty_box ())
    {
        player->inc_purse ();

        ret = didPlayerWin ();
    }

    next_player ();

    return ret;
}


bool Game::wrongAnswer ()
{
    Player *player = *currentPlayer;

    player->send_to_penalty ();

    next_player ();

    return true;
}


void Game::next_player ()
{
    ++currentPlayer;

    if (currentPlayer == players.end())
        currentPlayer = players.begin();
}

bool Game::didPlayerWin ()
{
    return ((*currentPlayer)->get_purse () != MAX_PURSE);
}
