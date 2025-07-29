#ifndef INPUT_H
#define INPUT_H

#include <stdlib.h>

typedef int (*die_func_t)(void);
typedef int (*response_is_correct_func_t)(void);

static int random_die(void) {
    return rand() % 5 + 1;
}

static int random_response_is_correct(void) {
    return rand() % 9 != 7;
}

#endif /* INPUT_H */