#include <stdlib.h>
#include <time.h>
#include "game.h"


int
main ()
{
  newGame();

  add ("Chet");
  add ( "Pat");
  add ( "Sue");

	srand ((unsigned)time(0));

      do
	{
	  roll ( rand () % 5 + 1);

	  if (rand () % 9 == 7)
	    {
	      wrong_answer ();
	    }
	  else
	    {
	      was_correctly_answered ();
	    }
	}
      while (not_a_winner);
  }
