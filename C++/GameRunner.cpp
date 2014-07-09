#include <stdlib.h>

#include "Game.h"

static bool notAWinner;

int main()
{
    Game aGame;

    aGame.add_player ("Chet");
    aGame.add_player ("Pat");
    aGame.add_player ("Sue");

    do
    {
        aGame.roll (rand() % 5 + 1);

        if (rand() % 9 == 7)
        {
            notAWinner = aGame.wrong_answer ();
        }
        else
        {
            notAWinner = aGame.right_answer ();
        }
    } while (notAWinner);

    return 0;
}
