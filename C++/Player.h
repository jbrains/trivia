#ifndef PLAYER_H_
#define PLAYER_H_

#include <string>

class Player
{

public:
    // Constructor that initialize the name of the player.
    Player (std::string name);

    // Returns the name of the player.
    std::string get_name (void) const;

    // Returns the place of the player.
    int get_place (void) const;

    // Returns the purse of the player.
    int get_purse (void) const;

    // Asks if the player is in the penalty box.
    bool is_in_penalty_box (void) const;

    // Increment the purse.
    void add_gold (void);

    // Increments the place by a given value and
    // gets its modulo by max_place.
    void step (int, int);

    // Sends the player into the penalty box.
    void send_to_penalty (void);

    // Gets the player out of the penalty box.
    void get_from_penalty (void);

private:
    // The name of the player.
    const std::string _name;

    // Current place of the player.
    int _place;

    // Amount of gold coins that the player has.
    int _purse;

    // Is the player in the penalty box?
    bool _in_penalty_box;
};

#endif // PLAYER_H_
