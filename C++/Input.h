#ifndef INPUT_H_
#define INPUT_H_

class Input {
public:
    virtual ~Input() = default;
    virtual int die() = 0;
    virtual bool responseIsCorrect() = 0;
};

#endif /* INPUT_H_ */