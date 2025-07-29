#include "Game.h"
#include "Input.h"
#include <iostream>

#ifndef GAMERUNNER_H_
#define GAMERUNNER_H_

using namespace std;

class GameRunner {
private:
    Input* input;
    ostream& output;
    
public:
    GameRunner(Input* input, ostream& output);
    void run();
};

#endif /* GAMERUNNER_H_ */