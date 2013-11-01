#ifndef GAME_H
#define GAME_H

#include <stdbool.h>

struct Game;

struct Game *game_new ();
void game_create_rock_question (struct Game *game, int index);
bool game_is_playable (struct Game *game);
bool game_add (struct Game *game, const char *player_name);

int game_how_many_players (struct Game *game);
void game_roll (struct Game *game, int roll);

bool game_was_correctly_answered (struct Game *game);
bool game_wrong_answer (struct Game *game);

#endif /* GAME_H */
