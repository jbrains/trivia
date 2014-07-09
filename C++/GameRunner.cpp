#include <stdlib.h>

#include "Game.h"

int main()
{
    Game aGame;

    aGame.add_player ("Chet");
    aGame.add_player ("Pat");
    aGame.add_player ("Sue");

    do
    {
        aGame.roll (rand() % 5 + 1);
    } while (! aGame.answer (rand() % 9 != 7));

    return 0;
}
