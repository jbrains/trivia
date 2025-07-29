#include <stdlib.h>
#include <time.h>
#include "game.h"
#include "input.h"
#include "output.h"

void run_game(die_func_t die_func, response_is_correct_func_t response_is_correct_func, write_func_t write_func)
{
  newGame();

  add("Chet", write_func);
  add("Pat", write_func);
  add("Sue", write_func);

  do
  {
    roll(die_func(), write_func);

    if (!response_is_correct_func())
    {
      wrong_answer(write_func);
    }
    else
    {
      was_correctly_answered(write_func);
    }
  } while (not_a_winner);
}
