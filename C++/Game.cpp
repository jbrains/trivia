#include "Game.h"
#include "Printer.h"
#include "Player.h"
#include "QuestionCategory.h"

#include <iostream>
#include <sstream>

#define NUM_OF_QUESTIONS 50
#define MAX_PLACE 12
#define MIN_PLAYER 2
#define MAX_PURSE 6

const std::vector<std::string> Game::category_names =
                                   {"Pop", "Science", "Sports", "Rock"};

// Constructor that initialize the starting state of the game.
Game::Game ()
{
    init_categories ();
}


// Initialization method for question categories.
void Game::init_categories ()
{
    // Iterates trough the category names and create
    // category and questions for each.
    for (std::vector<std::string>::const_iterator topic = 
            Game::category_names.begin();
         topic != category_names.end();
         ++topic)
    {
        categories.push_back (generate_questions (*topic));
    }
}


// Generation method for question categories.
QuestionCategory* Game::generate_questions (std::string topic)
{
    QuestionCategory *category = new QuestionCategory (topic);

    // TODO: It would be better to read questions from some resource
    // instead of generating dummy questions
    for (int i = 0; i < NUM_OF_QUESTIONS; ++i)
    {
        std::ostringstream oss (std::ostringstream::out);

        oss << topic << " Question " << i;

        category->add_question (oss.str ());
    }

    return category;
}


// Checks if there are enough player to play.
bool Game::is_playable ()
{
    return (players.size () >= MIN_PLAYER);
}


// Adds a new player to the game.
bool Game::add_player (string player_name)
{
    Player *player = new Player (player_name);
    players.push_back (player);

    Printer::new_player_added (player, players.size ());

    current_player = players.begin ();

    return true;
}


// The actual players roll.
void Game::roll (int roll)
{
    Player *player = *current_player;

    Printer::player_rolled (player, roll);

    if ((player->is_in_penalty_box ()) && (roll % 2 == 0))
    {
        Printer::stay_in_penalty (player);
    }
    else
    {
        player->get_from_penalty ();

        player->step (roll, MAX_PLACE);

        int cat = player->get_place () % categories.size ();
        Printer::new_location (player, categories[cat]);

        ask_question ();
    }
}


// Prints out the next question of the cathegory of the current player's place.
void Game::ask_question ()
{
    // The index of the category where the question comes from
    const int cat = (*current_player)->get_place () % categories.size ();

    // TODO: Catching this on higher level may be better
    try
    {
        Printer::print_question(categories[cat]->next_question ());
    }
    catch (std::runtime_error err)
    {
        Printer::error (err.what ());
    }
}


// Answer the question right or wrong (true = right)
void Game::answer (bool is_right)
{
    Player *player = *current_player;

    if (is_right)
    {
        // If the player is in the penalty box, his answer has no effect.
        if (!player->is_in_penalty_box ())
        {
            // The players get one gold for every answer.
            player->add_gold ();

            Printer::correct_answer (player);
        }
    }
    else
    {
        Printer::incorrect_answer (player);

        // If the answer was wrong, the player goes to the penalty box.
        player->send_to_penalty ();
    }
}


// Sets the next player if the game continues, otherwise returns false
bool Game::next_round ()
{
    // Return value, that says if the game continues or not.
    bool go = false;

    if (!did_player_win ())
    {
        next_player ();
        go = true;
    }

    return go;
}


// Set the next player to actor.
void Game::next_player ()
{
    ++current_player;

    // After the last player the first will come.
    if (current_player == players.end())
        current_player = players.begin();
}


// Checks if the current player won the game.
bool Game::did_player_win ()
{
    // The game keeps running until one of the players gets the
    // maximal amount of gold coins. 
    return ((*current_player)->get_purse () == MAX_PURSE);
}
