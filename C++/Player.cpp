#include "Player.h"

int Player::_max_place;

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
void Player::inc_purse ()
{
    ++_purse;
}


// Increment the purse.
void Player::inc_place (int n)
{
    // If the current place + n greater than the number of places 
    // it cuts by modulo.
    _place = (_place + n) % _max_place;
}


// Sets the maximum number of places.
void Player::set_max_place (int max)
{
    Player::_max_place = max;
}
