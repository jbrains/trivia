/**\file
 *  FILE DESCRIPTION
 *  --------------------------------------------------------------------------
 *  File name: GameRunner.cpp
 *
 *  Short Description:
 *  Run and use the Game class.
 */

/*============================================================================*\
 * PREPROCESSOR DIRECTIVES
\*============================================================================*/

/* INCLUDE DIRECTIVES FOR STANDARD HEADERS -----------------------------------*/

#include <stdlib.h>
#include <time.h>

/* INCLUDE DIRECTIVES FOR OTHER HEADERS --------------------------------------*/

#include "Game.h"

/*============================================================================*\
 * MEMBER FUNCTION DEFINITIONS
\*============================================================================*/

static bool notAWinner = true;

int main()
{

	srand(time(NULL));
	game::Game aGame;

	aGame.add("Chet");
	aGame.add("Pat");
	aGame.add("Sue");

	do
	{

		aGame.roll(rand() % 5U + 1U);

		if (rand() % 9U == 7U)
		{
			aGame.wrongAnswer();
		}
		else
		{
			notAWinner = aGame.wasCorrectlyAnswered();
		}
	} while (notAWinner);

}

/*============================================================================*\
 * END OF FILE
\*============================================================================*/
