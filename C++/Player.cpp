#include "Player.h"

int Player::_max_place;

Player::Player (std::string name) :
    _name (name),
    _purse (0),
    _place (0),
    _in_penalty_box (false) {}


std::string Player::get_name () const
{
    return _name;
}


int Player::get_purse () const
{
    return _purse;
}


int Player::get_place () const
{
    return _place;
}


bool Player::is_in_penalty_box () const
{
    return _in_penalty_box;
}


void Player::get_from_penalty ()
{
    _in_penalty_box = false;
}


void Player::send_to_penalty ()
{
    _in_penalty_box = true;
}


void Player::inc_purse ()
{
    ++_purse;
}


void Player::inc_place (int n)
{
    _place = (_place + n) % _max_place;
}


void Player::set_max_place (int max)
{
    Player::_max_place = max;
}
