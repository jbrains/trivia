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
    Game (void);

    bool is_playable (void);

    bool add_player (string);

    void roll (int);

    bool right_answer (void);

    bool wrong_answer (void);

    // Initialization method for question categories. 
    void init_categories (void);

    // Generation method for question categories.
    QuestionCategory* generate_questions (std::string);

    static const std::vector<std::string> category_names;

private:
    vector<Player*> players;

    vector<QuestionCategory*> categories;

    vector<Player*>::iterator current_player;

    void ask_question ();

    bool did_player_win ();

    void next_player (void);
};

#endif /* GAME_H_ */
