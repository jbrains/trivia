#include "game.h"
#include "game_runner.h"
#include "reference_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdarg.h>

static char fake_output_buffer[50000];
static int fake_output_pos = 0;

static int fake_responses[1000];
static int fake_dice[1000];
static int fake_response_index = 0;
static int fake_die_index = 0;

static int fake_print(const char *format, ...)
{
    va_list args;
    va_start(args, format);
    int result = vsprintf(fake_output_buffer + fake_output_pos, format, args);
    fake_output_pos += result;
    va_end(args);
    return result;
}

static int fake_die(void)
{
    return fake_dice[fake_die_index++];
}

static bool fake_response(void)
{
    return fake_responses[fake_response_index++] != 7;
}

static char* load_expected_output(void)
{
    FILE *file = fopen("../reference/result.txt", "r");
    if (!file) {
        printf("Error: Could not open result file\n");
        exit(1);
    }
    
    static char expected[50000];
    fread(expected, 1, sizeof(expected), file);
    fclose(file);
    
    int len = strlen(expected);
    while (len > 0 && (expected[len-1] == '\n' || expected[len-1] == '\r')) {
        expected[--len] = '\0';
    }
    
    return expected;
}

int main(void)
{
    load_reference_sequences(fake_responses, fake_dice, 1000);
    
    struct Game *game = game_new_with_deps(fake_print, fake_die, fake_response);
    
    run_game(game);
    
    char *expected = load_expected_output();
    
    if (fake_output_pos > 0 && fake_output_buffer[fake_output_pos-1] == '\n') {
        fake_output_buffer[fake_output_pos-1] = '\0';
    }
    
    if (strcmp(fake_output_buffer, expected) == 0) {
        printf("TEST PASSED: Game output matches expected result!\n");
        return 0;
    } else {
        printf("TEST FAILED: Game output does not match expected result!\n");
        printf("\n=== EXPECTED ===\n%s\n", expected);
        printf("\n=== ACTUAL ===\n%s\n", fake_output_buffer);
        return 1;
    }
}