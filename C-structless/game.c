#include "game.h"
#include "player.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
static void create_rock_question ();
const char *current_category ( void );


void newGame ( void )
{
  int i;
  player_num = 0;
  current_player = 0;

  pop_question = pop_questions;
  science_question = science_questions;
  sports_question = sports_questions;
  rock_question = rock_questions;

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
ask_question ( void )
{
  if (!strcmp (current_category (), "Pop"))
    {
      printf ("%s\n", *(++pop_question));
    }
  if (!strcmp (current_category (), "Science"))
    {
      printf ("%s\n", *(++science_question));
    }
  if (!strcmp (current_category (), "Sports"))
    {
      printf ("%s\n", *(++sports_question));
    }
  if (!strcmp (current_category (), "Rock"))
    {
      printf ("%s\n", *(++rock_question));
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
was_correctly_answered (void )
{
  if (in_penalty_box[current_player])
    {
      if (is_getting_out_of_penalty_box)
	{
	  printf ("Answer was correct!!!!\n");
	  purses[current_player]++;
	  printf ("%s now has %d Gold Coins.\n",
		  players[current_player],
		  purses[current_player]);
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

      printf ("Answer was corrent!!!!\n");
      purses[current_player]++;
      printf ("%s now has %d Gold Coins.\n",
	      players[current_player],
	      purses[current_player]);

      bool winner = did_player_win ();
      current_player++;
      if (current_player == player_num)
	current_player = 0;
    not_a_winner = winner;
    }
}

void
wrong_answer (void )
{
  printf ("Question was incorrectly answered\n");
  printf ("%s was sent to the penalty box\n",
	  players[current_player]);
  in_penalty_box[current_player] = true;

  current_player++;
  if (current_player == player_num)
    current_player = 0;
}


