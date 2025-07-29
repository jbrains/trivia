#include "game.h"
#include "player.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


typedef char Question[255];

Question pop_questions[50];
Question science_questions[50];
Question sports_questions[50];
Question rock_questions[50];

Question *pop_question;
Question *science_question;
Question *sports_question;
Question *rock_question;
extern  char *players[];
bool is_getting_out_of_penalty_box;
extern int not_a_winner;
static void create_rock_question (int index);
const char *current_category ( void );
void ask_question ( write_func_t write_func );


void newGame ( void )
{
  int i;
  player_num = 0;
  current_player = 0;

  pop_question = pop_questions - 1;
  science_question = science_questions - 1;
  sports_question = sports_questions - 1;
  rock_question = rock_questions - 1;

  for (i = 0; i < 50; i++)
    {
      sprintf (pop_questions[i], "Pop Question %d", i);
      sprintf (science_questions[i], "Science Question %d", i);
      sprintf (sports_questions[i], "Sports Question %d", i);
      create_rock_question (i);
    }
}

extern int how_many_players (void);

void
create_rock_question (int index)
{
  sprintf (rock_questions[index], "Rock Question %d", index);
}

bool
is_playable ( void )
{
  return (how_many_players () >= 2);
}




void
ask_question ( write_func_t write_func )
{
  if (!strcmp (current_category (), "Pop"))
    {
      write_func (*(++pop_question));
    }
  if (!strcmp (current_category (), "Science"))
    {
      write_func (*(++science_question));
    }
  if (!strcmp (current_category (), "Sports"))
    {
      write_func (*(++sports_question));
    }
  if (!strcmp (current_category (), "Rock"))
    {
      write_func (*(++rock_question));
    }
}

extern int places[];

const char *
current_category ( void )
{
  if (places[current_player] == 0)
    return "Pop";
  if (places[current_player] == 4)
    return "Pop";
  if (places[current_player] == 8)
    return "Pop";
  if (places[current_player] == 1)
    return "Science";
  if (places[current_player] == 5)
    return "Science";
  if (places[current_player] == 9)
    return "Science";
  if (places[current_player] == 2)
    return "Sports";
  if (places[current_player] == 6)
    return "Sports";
  if (places[current_player] == 10)
    return "Sports";
  return "Rock";
}

extern int purses[6];
void
was_correctly_answered ( write_func_t write_func )
{
  char message[256];
  if (in_penalty_box[current_player])
    {
      if (is_getting_out_of_penalty_box)
	{
	  write_func ("Answer was correct!!!!");
	  purses[current_player]++;
	  sprintf (message, "%s now has %d Gold Coins.",
		  players[current_player],
		  purses[current_player]);
	  write_func (message);
	  bool winner = did_player_win ();
	  current_player++;
	  if (current_player == player_num)
	    current_player = 0;

	  not_a_winner = winner;
	}
      else
	{
	  current_player++;
	  if (current_player == player_num)
	    current_player = 0;
	  not_a_winner = true;
	}



    }
  else
    {

      write_func ("Answer was corrent!!!!");
      purses[current_player]++;
      sprintf (message, "%s now has %d Gold Coins.",
	      players[current_player],
	      purses[current_player]);
      write_func (message);

      bool winner = did_player_win ();
      current_player++;
      if (current_player == player_num)
	current_player = 0;
    not_a_winner = winner;
    }
}

void
wrong_answer ( write_func_t write_func )
{
  char message[256];
  write_func ("Question was incorrectly answered");
  sprintf (message, "%s was sent to the penalty box",
	  players[current_player]);
  write_func (message);
  in_penalty_box[current_player] = true;

  current_player++;
  if (current_player == player_num)
    current_player = 0;
}


