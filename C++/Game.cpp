#include "Game.h"

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>

using namespace std;

Game::Game () : currentPlayer (0)
{
    for (int i = 0; i < 50; i++)
    {
        ostringstream oss (ostringstream::out);
        oss << "Pop Question " << i;

        popQuestions.push_back (oss.str ());

        char str[255];
        sprintf (str, "Science Question %d", i);
        scienceQuestions.push_back (str);

        char str1[255];
        sprintf (str1, "Sports Question %d", i);
        sportsQuestions.push_back (str1);

        rockQuestions.push_back (createRockQuestion (i));

        Player::set_max_place (12);
    }
}


string Game::createRockQuestion (int index)
{
    char indexStr[127];
    sprintf (indexStr, "Rock Question %d", index);
    return indexStr;
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
             << currentCategory ()
             << endl;

        askQuestion ();
    }
}


void Game::askQuestion ()
{
    if (currentCategory () == "Pop")
    {
        cout << popQuestions.front () << endl;
        popQuestions.pop_front ();
    }

    if (currentCategory () == "Science")
    {
        cout << scienceQuestions.front () << endl;
        scienceQuestions.pop_front ();
    }

    if (currentCategory () == "Sports")
    {
        cout << sportsQuestions.front () << endl;
        sportsQuestions.pop_front ();
    }

    if (currentCategory () == "Rock")
    {
        cout << rockQuestions.front () << endl;
        rockQuestions.pop_front ();
    }
}

string Game::currentCategory ()
{
    const int place = players[currentPlayer]->get_place ();

    if (place == 0) return "Pop";
    if (place == 4) return "Pop";
    if (place == 8) return "Pop";
    if (place == 1) return "Science";
    if (place == 5) return "Science";
    if (place == 9) return "Science";
    if (place == 2) return "Sports";
    if (place == 6) return "Sports";
    if (place == 10) return "Sports";

    return "Rock";
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
