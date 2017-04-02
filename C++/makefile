GAME=game
SRC=$(wildcard ./*.cpp)
OBJ=$(subst .cpp,.o,$(SRC))

CXX=g++
CPPFLAGS=-O2 -c -std=c++0x

all: $(GAME)

$(GAME): $(OBJ)
	$(CXX) -o $(GAME) $(OBJ)

%.o: %.cpp
	$(CXX) $(CPPFLAGS) $<

clean:
	rm -rf $(OBJ) $(GAME)

