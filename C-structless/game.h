#ifndef GAME_H
#define GAME_H

#include "player.h"

struct Game;

void newGame ( void );
bool is_playable ( void );
void roll( int roll );
extern int not_a_winner;

void was_correctly_answered (void );
void wrong_answer (void );

#endif /* GAME_H */
