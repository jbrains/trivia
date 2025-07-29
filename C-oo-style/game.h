#ifndef GAME_H
#define GAME_H

#include <stdbool.h>

struct Game;

typedef int (*print_func_t)(const char *format, ...);
typedef int (*die_func_t)(void);
typedef bool (*response_func_t)(void);

struct Game *game_new ();
struct Game *game_new_with_deps (print_func_t print_func, die_func_t die_func, response_func_t response_func);
void game_create_rock_question (struct Game *game, int index);
bool game_is_playable (struct Game *game);
bool game_add (struct Game *game, const char *player_name);

int game_how_many_players (struct Game *game);
void game_roll (struct Game *game, int roll);

bool game_was_correctly_answered (struct Game *game);
bool game_wrong_answer (struct Game *game);

int game_roll_die (struct Game *game);
bool game_is_response_correct (struct Game *game);

#endif /* GAME_H */
