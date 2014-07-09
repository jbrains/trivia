#ifndef GAME_H_
#define GAME_H_

#include <iostream>
#include <vector>

class Player;
class QuestionCategory;

using namespace std;

// Class for control the game actions.
class Game
{
public:
    // Constructor that initialize the starting state of the game.
    Game (void);

    // Checks if there are enough players to play.
    bool is_playable (void);

    // Adds a new player to the game.
    bool add_player (string);

    // The actual players roll.
    void roll (int);

    // Answer the question right or wrong (true = right)
    bool answer (bool);

private:
    // Initialization method for question categories. 
    void init_categories (void);

    // Generation method for question categories.
    QuestionCategory* generate_questions (std::string);

    // Const vector for defining the categories
    // TODO: it is a dummy solution, it should be read from config file(s).
    static const std::vector<std::string> category_names;

    // The players.
    vector<Player*> players;

    // The questions by categories
    vector<QuestionCategory*> categories;

    // Iterator for store which player acts currently.
    vector<Player*>::iterator current_player;

    // Prints out the next question of the cathegory of the
    // current players place.
    void ask_question ();

    // Checks if the current player won the game.
    bool did_player_win ();

    // Set the next player to actor.
    void next_player (void);
};

#endif /* GAME_H_ */
