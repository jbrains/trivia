#ifndef PLAYER_H_
#define PLAYER_H_

#include <stdbool.h>

extern int player_num;
extern int current_player;
extern bool in_penalty_box[6];
bool add (const char *player_name);
bool did_player_win ( void );


#endif /* PLAYER_H_ */
