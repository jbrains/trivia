#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "game.h"
#include "input.h"
#include "output.h"

void run_game(die_func_t die_func, response_is_correct_func_t response_is_correct_func, write_func_t write_func);

static FILE* open_file_or_exit(const char* filename, const char* mode);
static void remove_trailing_newline(char* str, size_t len);
static int parse_csv_tokens(char* line, int* values, int max_count);

static char output_buffer[50000];
static size_t output_len = 0;

void fake_write(const char* message) {
    size_t msg_len = strlen(message);
    if (output_len + msg_len + 1 < sizeof(output_buffer)) {
        strcpy(output_buffer + output_len, message);
        output_len += msg_len;
        output_buffer[output_len++] = '\n';
        output_buffer[output_len] = '\0';
    }
}

void clear_output(void) {
    output_buffer[0] = '\0';
    output_len = 0;
}

const char* get_output(void) {
    remove_trailing_newline(output_buffer, output_len);
    return output_buffer;
}

static int dice_values[100];
static int response_values[100];
static int dice_index = 0;
static int response_index = 0;
static int dice_count = 0;
static int response_count = 0;

static FILE* open_file_or_exit(const char* filename, const char* mode) {
    FILE *file = fopen(filename, mode);
    if (!file) {
        fprintf(stderr, "Error: Could not open file: %s\n", filename);
        exit(1);
    }
    return file;
}

static void remove_trailing_newline(char* str, size_t len) {
    if (len > 0 && str[len - 1] == '\n') {
        str[len - 1] = '\0';
    }
}

static int parse_csv_tokens(char* line, int* values, int max_count) {
    char *token = strtok(line, ",");
    int count = 0;
    while (token != NULL && count < max_count) {
        values[count++] = atoi(token);
        token = strtok(NULL, ",");
    }
    return count;
}

void load_reference_data(const char* filename) {
    FILE *file = open_file_or_exit(filename, "r");
    
    char line[1000];
    int line_num = 0;
    
    while (fgets(line, sizeof(line), file)) {
        line_num++;
        
        if (line_num == 2) {
            response_count = parse_csv_tokens(line, response_values, 100);
        } else if (line_num == 5) {
            dice_count = parse_csv_tokens(line, dice_values, 100);
        }
    }
}

int fake_die(void) {
    if (dice_index >= dice_count) {
        fprintf(stderr, "Error: Ran out of dice values from reference data\n");
        exit(1);
    }
    return dice_values[dice_index++];
}

int fake_response_is_correct(void) {
    if (response_index >= response_count) {
        fprintf(stderr, "Error: Ran out of response values from reference data\n");
        exit(1);
    }
    return response_values[response_index++] != 7;
}

/* Test function that compares output with expected result */
int run_test(void) {
    /* Load expected result */
    FILE *result_file = open_file_or_exit("../reference/result.txt", "r");
    
    /* Read expected result into buffer */
    char expected_result[50000];
    size_t expected_len = 0;
    int c;
    while ((c = fgetc(result_file)) != EOF && expected_len < sizeof(expected_result) - 1) {
        expected_result[expected_len++] = c;
    }
    expected_result[expected_len] = '\0';
    fclose(result_file);

    remove_trailing_newline(expected_result, expected_len);

    clear_output();

    run_game(fake_die, fake_response_is_correct, fake_write);

    const char *actual_result = get_output();
    
    if (strcmp(actual_result, expected_result) == 0) {
        printf("TEST PASSED: Output matches expected result exactly!\n");
        return 0;
    } else {
        printf("TEST FAILED: Output does not match expected result\n");
        printf("\n--- EXPECTED ---\n%s\n", expected_result);
        printf("\n--- ACTUAL ---\n%s\n", actual_result);

        size_t i = 0;
        while (expected_result[i] && actual_result[i] && 
               expected_result[i] == actual_result[i]) {
            i++;
        }
        printf("\nFirst difference at position %zu:\n", i);
        printf("Expected: '%c' (0x%02x)\n", expected_result[i], (unsigned char)expected_result[i]);
        printf("Actual:   '%c' (0x%02x)\n", actual_result[i], (unsigned char)actual_result[i]);
        
        return 1;
    }
}

int main() {
    printf("Loading reference data...\n");
    load_reference_data("../reference/randomSeq.txt");
    
    printf("Running deterministic test...\n");
    int result = run_test();
    
    if (result == 0) {
        printf("All tests passed!\n");
    } else {
        printf("Tests failed!\n");
    }
    
    return result;
}