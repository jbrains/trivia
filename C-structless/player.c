#include "player.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



char *players[50];
int current_player;
int not_a_winner = 5;
extern bool is_getting_out_of_penalty_box;
extern const char *current_category ( void );
extern void ask_question ( void );

int player_num;

int
how_many_players ( void )
{
	return player_num;
}

int places[6], purses[6];

bool in_penalty_box[6];
bool
add ( const char *player_name)
{
	players[how_many_players ()] = strdup (player_name);
	places[how_many_players ()] = 0;
	purses[how_many_players ()] = 0;
	in_penalty_box[how_many_players ()] = false;

	printf ("%s was added\n", player_name);
	printf ("They are player number %d\n", ++player_num);

	return true;
}


void
roll ( int roll)
{
  printf ("%s is the current player\n", players[current_player]);
  printf ("They have rolled a %d\n", roll);

  if (in_penalty_box[current_player])
    {
      if (roll % 2 != 0)
	{
	  is_getting_out_of_penalty_box = true;

	  printf ("%s is getting out of the penalty box\n",
		  players[current_player]);
	  places[current_player] =
	    places[current_player] + roll;
	  if (places[current_player] > 11)
	    places[current_player] =
	      places[current_player] - 12;

	  printf ("%s's new location is %d\n",
		  players[current_player],
		  places[current_player]);
	  printf ("The category is %s\n", current_category ());
	  ask_question ();
	}
      else
	{
	  printf ("%s is not getting out of the penalty box\n",
		  players[current_player]);
	  is_getting_out_of_penalty_box = false;
	}
    }
  else
    {
      places[current_player] =
	places[current_player] + roll;
      if (places[current_player] > 11)
	places[current_player] =
	  places[current_player] - 12;

      printf ("%s's new location is %d\n",
	      players[current_player],
	      places[current_player]);
      printf ("The category is %s\n", current_category ());
      ask_question ();
    }
}

bool
did_player_win ( void )
{
  return !(purses[current_player] == 6);
}
