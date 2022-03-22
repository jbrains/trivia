FILES=GameRunner.lpr
CC=fpc
OPTS=-Mobjfpc -FUout
OUTOPTS=-o
OUT=trivia

all: prod 

prod: build run

.outputFolder:
	mkdir -p out

build: .outputFolder
	$(CC) $(OPTS) $(OUTOPTS)$(OUT) $(FILES)

run: 
	./$(OUT)

clean: 
	rm -rf out/
	rm -f $(OUT)
