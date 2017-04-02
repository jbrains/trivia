#include "Player.h"

// Constructor that initialize the name of the player.
Player::Player (std::string name) :
    _name (name),
    _purse (0),
    _place (0),
    _in_penalty_box (false) {}


// Returns the name of the player.
std::string Player::get_name () const
{
    return _name;
}


// Returns the purse of the player.
int Player::get_purse () const
{
    return _purse;
}


// Returns the place of the player.
int Player::get_place () const
{
    return _place;
}


// Asks if the player is in the penalty box.
bool Player::is_in_penalty_box () const
{
    return _in_penalty_box;
}


// Gets the player out of the penalty box.
void Player::get_from_penalty ()
{
    _in_penalty_box = false;
}


// Sends the player into the penalty box.
void Player::send_to_penalty ()
{
    _in_penalty_box = true;
}


// Increment the purse.
void Player::add_gold ()
{
    ++_purse;
}


// Step with the player on a 'max' sized table.
void Player::step (int n, int max)
{
    // If the current place + n greater than the number of places 
    // it cuts by modulo.
    _place = (_place + n) % max;
}
