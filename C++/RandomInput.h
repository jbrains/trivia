#include "Input.h"
#include <cstdlib>
#include <ctime>

#ifndef RANDOMINPUT_H_
#define RANDOMINPUT_H_

class RandomInput : public Input {
public:
    RandomInput() {
        srand(time(NULL));
    }
    
    virtual int die() override {
        return rand() % 5 + 1;
    }
    
    virtual bool responseIsCorrect() override {
        return rand() % 9 != 7;
    }
};

#endif /* RANDOMINPUT_H_ */