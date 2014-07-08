#ifndef GAME_H_
#define GAME_H_

#include <iostream>
#include <vector>

#include "Player.h"
#include "QuestionCategory.h"

using namespace std;

class Game
{
public:
    Game ();

    bool isPlayable ();

    bool add (string playerName);

    int howManyPlayers ();

    void roll (int roll);

    bool wasCorrectlyAnswered ();

    bool wrongAnswer ();

    // Initialization method for question categories. 
    void init_categories (void);

    // Generation method for question categories.
    QuestionCategory* generate_questions (std::string);

    static const std::vector<std::string> category_names;

private:
    vector<Player*> players;

    vector<QuestionCategory*> categories;

    int currentPlayer;

    bool isGettingOutOfPenaltyBox;

    void askQuestion ();

    string currentCategory ();

    bool didPlayerWin ();
};

#endif /* GAME_H_ */
