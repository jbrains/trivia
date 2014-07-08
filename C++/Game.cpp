#include "Game.h"

#include <iostream>
#include <sstream>

#define NUM_OF_QUESTIONS 50

const std::vector<std::string> Game::category_names =
                                   {"Pop", "Science", "Sports", "Rock"};

Game::Game ()
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

    currentPlayer = players.begin ();

    return true;
}


int Game::howManyPlayers ()
{
    return players.size ();
}


void Game::roll (int roll)
{
    Player *player = *currentPlayer;

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
    // The place of current player
    const int place = (*currentPlayer)->get_place ();
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
    Player *player = *currentPlayer;
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

    next_player ();

    return ret;
}

bool Game::wrongAnswer ()
{
    Player *player = *currentPlayer;

    cout << "Question was incorrectly answered"
         << endl
         << player->get_name ()
	 << " was sent to the penalty box"
	 << endl;

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
    return ((*currentPlayer)->get_purse () != 6);
}
