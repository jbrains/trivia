#include <stdlib.h>
#include "GameRunner.h"
#include "RandomInput.h"

GameRunner::GameRunner(Input* input, ostream& output) : input(input), output(output) {}

void GameRunner::run() {
	Game aGame(output);

	aGame.add("Chet");
	aGame.add("Pat");
	aGame.add("Sue");

	bool notAWinner;
	do
	{
		aGame.roll(input->die());

		if (!input->responseIsCorrect())
		{
			notAWinner = aGame.wrongAnswer();
		}
		else
		{
			notAWinner = aGame.wasCorrectlyAnswered();
		}
	} while (notAWinner);

}
