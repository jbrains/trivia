#include "game.h"
#include "input.h"
#include "output.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>

typedef char Question[255];

Question pop_questions[50];
Question science_questions[50];
Question sports_questions[50];
Question rock_questions[50];

struct Game
{
  int places[6];
  int purses[6];

  bool in_penalty_box[6];

  int player_num;
  char *players[50];

  Question *pop_question;
  Question *science_question;
  Question *sports_question;
  Question *rock_question;

  int current_player;
  bool is_getting_out_of_penalty_box;
  
  print_func_t print_func;
  die_func_t die_func;
  response_func_t response_func;
};

static void ask_question (struct Game *game);
static void create_rock_question (int index);
static const char *current_category (struct Game *game);

static bool did_player_win (struct Game *game);

struct Game *
game_new ()
{
  return game_new_with_deps(default_print, default_die, default_response);
}

struct Game *
game_new_with_deps (print_func_t print_func, die_func_t die_func, response_func_t response_func)
{
  int i;
  struct Game *game;

  game = malloc (sizeof (struct Game));
  game->player_num = 0;
  game->current_player = 0;

  game->pop_question = pop_questions;
  game->science_question = science_questions;
  game->sports_question = sports_questions;
  game->rock_question = rock_questions;
  
  game->print_func = print_func;
  game->die_func = die_func;
  game->response_func = response_func;

  for (i = 0; i < 50; i++)
    {
      sprintf (pop_questions[i], "Pop Question %d", i);
      sprintf (science_questions[i], "Science Question %d", i);
      sprintf (sports_questions[i], "Sports Question %d", i);
      create_rock_question (i);
    }

  return game;
}

void
create_rock_question (int index)
{
  sprintf (rock_questions[index], "Rock Question %d", index);
}

bool
game_is_playable (struct Game *game)
{
  return (game_how_many_players (game) >= 2);
}

bool
game_add (struct Game * game, const char *player_name)
{
  game->players[game_how_many_players (game)] = strdup (player_name);
  game->places[game_how_many_players (game)] = 0;
  game->purses[game_how_many_players (game)] = 0;
  game->in_penalty_box[game_how_many_players (game)] = false;

  game->print_func ("%s was added\n", player_name);
  game->print_func ("They are player number %d\n", ++game->player_num);

  return true;
}

int
game_how_many_players (struct Game *game)
{
  return game->player_num;
}

void
game_roll (struct Game *game, int roll)
{
  game->print_func ("%s is the current player\n", game->players[game->current_player]);
  game->print_func ("They have rolled a %d\n", roll);

  if (game->in_penalty_box[game->current_player])
    {
      if (roll % 2 != 0)
	{
	  game->is_getting_out_of_penalty_box = true;

	  game->print_func ("%s is getting out of the penalty box\n",
		  game->players[game->current_player]);
	  game->places[game->current_player] =
	    game->places[game->current_player] + roll;
	  if (game->places[game->current_player] > 11)
	    game->places[game->current_player] =
	      game->places[game->current_player] - 12;

	  game->print_func ("%s's new location is %d\n",
		  game->players[game->current_player],
		  game->places[game->current_player]);
	  game->print_func ("The category is %s\n", current_category (game));
	  ask_question (game);
	}
      else
	{
	  game->print_func ("%s is not getting out of the penalty box\n",
		  game->players[game->current_player]);
	  game->is_getting_out_of_penalty_box = false;
	}
    }
  else
    {
      game->places[game->current_player] =
	game->places[game->current_player] + roll;
      if (game->places[game->current_player] > 11)
	game->places[game->current_player] =
	  game->places[game->current_player] - 12;

      game->print_func ("%s's new location is %d\n",
	      game->players[game->current_player],
	      game->places[game->current_player]);
      game->print_func ("The category is %s\n", current_category (game));
      ask_question (game);
    }

}

void
ask_question (struct Game *game)
{
  if (!strcmp (current_category (game), "Pop"))
    {
      game->print_func ("%s\n", *game->pop_question);
      game->pop_question++;
    }
  if (!strcmp (current_category (game), "Science"))
    {
      game->print_func ("%s\n", *game->science_question);
      game->science_question++;
    }
  if (!strcmp (current_category (game), "Sports"))
    {
      game->print_func ("%s\n", *game->sports_question);
      game->sports_question++;
    }
  if (!strcmp (current_category (game), "Rock"))
    {
      game->print_func ("%s\n", *game->rock_question);
      game->rock_question++;
    }
}


const char *
current_category (struct Game *game)
{
  if (game->places[game->current_player] == 0)
    return "Pop";
  if (game->places[game->current_player] == 4)
    return "Pop";
  if (game->places[game->current_player] == 8)
    return "Pop";
  if (game->places[game->current_player] == 1)
    return "Science";
  if (game->places[game->current_player] == 5)
    return "Science";
  if (game->places[game->current_player] == 9)
    return "Science";
  if (game->places[game->current_player] == 2)
    return "Sports";
  if (game->places[game->current_player] == 6)
    return "Sports";
  if (game->places[game->current_player] == 10)
    return "Sports";
  return "Rock";
}

bool
game_was_correctly_answered (struct Game * game)
{
  if (game->in_penalty_box[game->current_player])
    {
      if (game->is_getting_out_of_penalty_box)
	{
	  game->print_func ("Answer was correct!!!!\n");
	  game->purses[game->current_player]++;
	  game->print_func ("%s now has %d Gold Coins.\n",
		  game->players[game->current_player],
		  game->purses[game->current_player]);
	  bool winner = did_player_win (game);
	  game->current_player++;
	  if (game->current_player == game->player_num)
	    game->current_player = 0;

	  return winner;
	}
      else
	{
	  game->current_player++;
	  if (game->current_player == game->player_num)
	    game->current_player = 0;
	  return true;
	}



    }
  else
    {

      game->print_func ("Answer was corrent!!!!\n");
      game->purses[game->current_player]++;
      game->print_func ("%s now has %d Gold Coins.\n",
	      game->players[game->current_player],
	      game->purses[game->current_player]);

      bool winner = did_player_win (game);
      game->current_player++;
      if (game->current_player == game->player_num)
	game->current_player = 0;

      return winner;
    }
}

bool
game_wrong_answer (struct Game * game)
{
  game->print_func ("Question was incorrectly answered\n");
  game->print_func ("%s was sent to the penalty box\n",
	  game->players[game->current_player]);
  game->in_penalty_box[game->current_player] = true;

  game->current_player++;
  if (game->current_player == game->player_num)
    game->current_player = 0;
  return true;
}


bool
did_player_win (struct Game * game)
{
  return !(game->purses[game->current_player] == 6);
}

int
game_roll_die (struct Game *game)
{
  return game->die_func();
}

bool
game_is_response_correct (struct Game *game)
{
  return game->response_func();
}
