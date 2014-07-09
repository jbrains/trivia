#include <stdlib.h>

#include "Game.h"

int main()
{
    Game aGame;

    // Add 3 players
    aGame.add_player ("Chet");
    aGame.add_player ("Pat");
    aGame.add_player ("Sue");

    // Roll nad answer the question while nobody won the game.
    do
    {
        aGame.roll (rand() % 5 + 1);
    } while (! aGame.answer (rand() % 9 != 7));
    // The players give right answers with 8/9 of probability

    return 0;
}
