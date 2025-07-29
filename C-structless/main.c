#include <stdlib.h>
#include <time.h>
#include "game.h"
#include "input.h"
#include "output.h"

void run_game(die_func_t die_func, response_is_correct_func_t response_is_correct_func, write_func_t write_func);

int main() 
{
  die_func_t die_func = random_die;
  response_is_correct_func_t response_is_correct_func = random_response_is_correct;
  write_func_t write_func = console_write;

  srand((unsigned)time(0));

  run_game(die_func, response_is_correct_func, write_func);

  return 0;
}