#ifndef GAME_H_
#define GAME_H_

#include <iostream>
#include <vector>

class Player;
class QuestionCategory;

using namespace std;

class Game
{
public:
    Game (void);

    bool is_playable (void);

    bool add_player (string);

    void roll (int);

    bool answer (bool);

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
