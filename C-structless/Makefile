CC = gcc
CFLAGS = -Wall -Wextra -Wno-unused-function -std=c99 -g

# Object files for the game library
GAME_OBJS = game.o player.o game_runner.o

# Main game executable
trivia: $(GAME_OBJS) main.o
	$(CC) $(CFLAGS) -o trivia $(GAME_OBJS) main.o

# Test executable  
test: $(GAME_OBJS) game_test.o
	$(CC) $(CFLAGS) -o test $(GAME_OBJS) game_test.o

# Object file rules
game.o: game.c game.h player.h
	$(CC) $(CFLAGS) -c game.c

player.o: player.c player.h game.h
	$(CC) $(CFLAGS) -c player.c

game_runner.o: game_runner.c game.h
	$(CC) $(CFLAGS) -c game_runner.c

main.o: main.c game.h
	$(CC) $(CFLAGS) -c main.c

game_test.o: game_test.c game.h
	$(CC) $(CFLAGS) -c game_test.c

# Build both main and test
all: trivia test

# Run the main game
run: trivia
	./trivia

# Run the test
run-test: test
	./test

# Clean up build artifacts
clean:
	rm -f *.o trivia test main

# Build and run test in one command
check: test
	./test

.PHONY: all run run-test clean check