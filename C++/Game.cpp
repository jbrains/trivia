#include "Game.h"

#include <iostream>
#include <sstream>

#define NUM_OF_QUESTIONS 50

const std::vector<std::string> Game::category_names =
                                   {"Pop", "Science", "Sports", "Rock"};

Game::Game () : currentPlayer (0)
{
    init_categories ();
    
    Player::set_max_place (12);
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
    return (howManyPlayers () >= 2);
}


bool Game::add (string playerName)
{
    players.push_back (new Player (playerName));

    cout << playerName << " was added" << endl;
    cout << "They are player number " << players.size () << endl;
    return true;
}


int Game::howManyPlayers ()
{
    return players.size ();
}


void Game::roll (int roll)
{
    Player *player = players[currentPlayer];

    cout << player->get_name ()
         << " is the current player"
         << endl;

    cout << "They have rolled a "
         << roll
         << endl;

    if ((player->is_in_penalty_box ()) && (roll % 2 == 0))
    {
        cout << player->get_name ()
             << " is not getting out of the penalty box"
             << endl;
    }
    else
    {
        player->get_from_penalty ();

        player->inc_place (roll);

        cout << player->get_name ()
             << "'s new location is "
             << player->get_place ()
             << endl;

        cout << "The category is "
             << Game::category_names [player->get_place () %
                                      category_names.size ()]
             << endl;

        askQuestion ();
    }
}


void Game::askQuestion ()
{
    // The place of current player # TODO: change currentPlayer to iterator
    const int place = players[currentPlayer]->get_place ();
    try
    {
        cout << categories[place % categories.size ()]->next_question ()
             << std::endl;
    } catch (std::runtime_error err)
    {
	    std::cout << "Error: " << err.what () << std::endl;
    }
}

bool Game::wasCorrectlyAnswered ()
{
    Player *player = players[currentPlayer];
    bool ret = true;

    if (!player->is_in_penalty_box ())
    {
        cout << "Answer was correct!!!!" << endl;

        player->inc_purse ();

        cout << player->get_name ()
             << " now has "
             << player->get_purse ()
             << " Gold Coins." << endl;

        ret = didPlayerWin ();
    }

    currentPlayer = (currentPlayer + 1) % players.size ();

    return ret;
}

bool Game::wrongAnswer ()
{
    Player *player = players[currentPlayer];

    cout << "Question was incorrectly answered"
         << endl
         << player->get_name ()
	 << " was sent to the penalty box"
	 << endl;

    player->send_to_penalty ();

    currentPlayer = (currentPlayer + 1) % players.size ();

    return true;
}

bool Game::didPlayerWin ()
{
    return (players[currentPlayer]->get_purse () != 6);
}
