#include "game.h"
#include "game_runner.h"

void
run_game (struct Game *a_game)
{
  bool not_a_winner;

  game_add (a_game, "Chet");
  game_add (a_game, "Pat");
  game_add (a_game, "Sue");

  do
    {
      game_roll (a_game, game_roll_die (a_game));

      if (!game_is_response_correct (a_game))
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