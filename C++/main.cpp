#include "GameRunner.h"
#include "RandomInput.h"
#include <iostream>

using namespace std;

int main()
{
	RandomInput input;
	GameRunner gameRunner(&input, cout);
	gameRunner.run();
	return 0;
}