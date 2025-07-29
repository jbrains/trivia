#ifndef OUTPUT_H
#define OUTPUT_H

#include <stdio.h>

typedef void (*write_func_t)(const char* message);

static void console_write(const char* message) {
    puts(message);
}

#endif /* OUTPUT_H */