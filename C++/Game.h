#ifndef GAME_H_
#define GAME_H_

#include <iostream>
#include <list>
#include <vector>

#include "Player.h"

using namespace std;

class Game
{
public:
    Game ();

    string createRockQuestion (int index);

    bool isPlayable ();

    bool add (string playerName);

    int howManyPlayers ();

    void roll (int roll);

    bool wasCorrectlyAnswered ();

    bool wrongAnswer ();

private:
    vector<Player*> players;

    list<string> popQuestions;

    list<string> scienceQuestions;

    list<string> sportsQuestions;

    list<string> rockQuestions;

    int currentPlayer;

    bool isGettingOutOfPenaltyBox;

    void askQuestion ();

    string currentCategory ();

    bool didPlayerWin ();
};

#endif /* GAME_H_ */
