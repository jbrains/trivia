#include <stdlib.h>
#include <time.h>
#include "game.h"

static bool not_a_winner;

int
main ()
{
  struct Game *a_game = game_new ();

  game_add (a_game, "Chet");
  game_add (a_game, "Pat");
  game_add (a_game, "Sue");

	srand ((unsigned)time(0));

      do
	{
	  game_roll (a_game, rand () % 5 + 1);

	  if (rand () % 9 == 7)
	    {
	      not_a_winner = game_wrong_answer (a_game);
	    }
	  else
	    {
	      not_a_winner = game_was_correctly_answered (a_game);
	    }
	}
      while (not_a_winner);
  }
