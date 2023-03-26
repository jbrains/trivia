FILES = GameRunner.cpp Game.cpp Game.h
TEST_FILES = Game.cpp Game.h
CC = g++
OPTS = -std=c++17 -Wall -Wextra -Werror
OUTOPTS = -o 
OUT = out/trivia
TEST_OUT = out/trivia_tests

all: prod 

prod: build run

tests: test runTest

.outputFolder:
	mkdir -p out

build: .outputFolder
	$(CC) $(FILES) $(OPTS) $(OUTOPTS) $(OUT)

run: 
	./$(OUT)

test: .outputFolder
	$(CC) $(TEST_FILES) $(OPTS) $(OUTOPTS) $(TEST_OUT)

runTest: 
	./$(TEST_OUT)

clean: 
	rm -rf out/
