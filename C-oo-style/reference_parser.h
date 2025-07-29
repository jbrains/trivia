#ifndef REFERENCE_PARSER_H
#define REFERENCE_PARSER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void parse_reference_line(const char *line, int *output, int max_count)
{
    char *line_copy = strdup(line);
    char *token = strtok(line_copy, ",");
    int i = 0;
    
    while (token && i < max_count) {
        output[i++] = atoi(token);
        token = strtok(NULL, ",");
    }
    
    free(line_copy);
}

static void load_reference_sequences(int *responses, int *dice, int max_count)
{
    FILE *file = fopen("../reference/randomSeq.txt", "r");
    if (!file) {
        printf("Error: Could not open reference file\n");
        exit(1);
    }
    
    char line[1000];
    int line_num = 0;
    
    while (fgets(line, sizeof(line), file)) {
        line_num++;
        if (line_num == 2) {
            parse_reference_line(line, responses, max_count);
        } else if (line_num == 5) {
            parse_reference_line(line, dice, max_count);
        }
    }
    
    fclose(file);
}

#endif /* REFERENCE_PARSER_H */