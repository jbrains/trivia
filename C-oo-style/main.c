#include <stdlib.h>
#include <time.h>
#include "game.h"
#include "game_runner.h"
#include "input.h"
#include "output.h"

int
main ()
{
  struct Game *a_game = game_new ();

  srand ((unsigned)time(0));
  run_game (a_game);

  return 0;
}

