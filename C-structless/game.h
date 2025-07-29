#ifndef GAME_H
#define GAME_H

#include "player.h"

struct Game;


void newGame ( void );
bool is_playable ( void );
void roll( int roll, write_func_t write_func );
extern int not_a_winner;

void was_correctly_answered ( write_func_t write_func );
void wrong_answer ( write_func_t write_func );

#endif /* GAME_H */
