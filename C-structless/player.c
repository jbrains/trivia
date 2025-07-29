#include "player.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



char *players[50];
int current_player;
int not_a_winner = 5;
extern bool is_getting_out_of_penalty_box;
extern const char *current_category ( void );
extern void ask_question ( write_func_t write_func );

int player_num;

int
how_many_players ( void )
{
	return player_num;
}

int places[6], purses[6];

bool in_penalty_box[6];
bool
add ( const char *player_name, write_func_t write_func)
{
	char message[256];
	players[how_many_players ()] = strdup (player_name);
	places[how_many_players ()] = 0;
	purses[how_many_players ()] = 0;
	in_penalty_box[how_many_players ()] = false;

	sprintf (message, "%s was added", player_name);
	write_func (message);
	sprintf (message, "They are player number %d", ++player_num);
	write_func (message);

	return true;
}


void
roll ( int roll, write_func_t write_func)
{
  char message[256];
  sprintf (message, "%s is the current player", players[current_player]);
  write_func (message);
  sprintf (message, "They have rolled a %d", roll);
  write_func (message);

  if (in_penalty_box[current_player])
    {
      if (roll % 2 != 0)
	{
	  is_getting_out_of_penalty_box = true;

	  sprintf (message, "%s is getting out of the penalty box",
		  players[current_player]);
	  write_func (message);
	  places[current_player] =
	    places[current_player] + roll;
	  if (places[current_player] > 11)
	    places[current_player] =
	      places[current_player] - 12;

	  sprintf (message, "%s's new location is %d",
		  players[current_player],
		  places[current_player]);
	  write_func (message);
	  sprintf (message, "The category is %s", current_category ());
	  write_func (message);
	  ask_question (write_func);
	}
      else
	{
	  sprintf (message, "%s is not getting out of the penalty box",
		  players[current_player]);
	  write_func (message);
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

      sprintf (message, "%s's new location is %d",
	      players[current_player],
	      places[current_player]);
      write_func (message);
      sprintf (message, "The category is %s", current_category ());
      write_func (message);
      ask_question (write_func);
    }
}

bool
did_player_win ( void )
{
  return !(purses[current_player] == 6);
}
