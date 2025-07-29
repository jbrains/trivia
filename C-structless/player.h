#ifndef PLAYER_H_
#define PLAYER_H_

#include <stdbool.h>
#include "output.h"


extern int player_num;
extern int current_player;
extern bool in_penalty_box[6];
bool add (const char *player_name, write_func_t write_func);
bool did_player_win ( void );


#endif /* PLAYER_H_ */
