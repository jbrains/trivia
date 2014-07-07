#ifndef GAME_H_
#define GAME_H_

#include <iostream>
#include <list>
#include <vector>
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
    vector<string> players;

    int places[6];

    int purses[6];

    bool inPenaltyBox[6];

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
