#ifndef INPUT_H
#define INPUT_H

#include <stdlib.h>
#include <stdbool.h>

static int default_die(void)
{
  return rand() % 5 + 1;
}

static bool default_response(void)
{
  return rand() % 9 != 7;
}

#endif /* INPUT_H */