#include "Game.h"
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>

using namespace std;

Game::Game() : currentPlayer(0), places({}), purses({}){
	for (int i = 0; i < 50; i++)
	{

		ostringstream oss (ostringstream::out);
		oss << "Pop Question " << i;

		popQuestions.push_back(oss.str());

		char str[255];
		sprintf(str, "Science Question %d", i);
		scienceQuestions.push_back(str);

		char str1[255];
		sprintf(str1, "Sports Question %d", i);
		sportsQuestions.push_back(str1);

		rockQuestions.push_back(createRockQuestion(i));
	}
}

string Game::createRockQuestion(int index)
{
	char indexStr[127];
	sprintf(indexStr, "Rock Question %d", index);
	return indexStr;
}

bool Game::isPlayable()
{
	return (howManyPlayers() >= 2);
}

bool Game::add(string playerName){
	players.push_back(playerName);
	places[howManyPlayers()] = 0;
	purses[howManyPlayers()] = 0;
	inPenaltyBox[howManyPlayers()] = false;

	cout << playerName << " was added" << endl;
	cout << "They are player number " << players.size() << endl;
	return true;
}

int Game::howManyPlayers()
{
	return players.size();
}

void Game::roll(int roll)
{
	cout << players[currentPlayer] << " is the current player" << endl;
	cout << "They have rolled a " << roll << endl;

	if (inPenaltyBox[currentPlayer])
	{
		if (roll % 2 != 0)
		{
			isGettingOutOfPenaltyBox = true;

			cout << players[currentPlayer] << " is getting out of the penalty box" << endl;
			places[currentPlayer] = places[currentPlayer] + roll;
			if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;

			cout << players[currentPlayer] << "'s new location is " << places[currentPlayer] << endl;
			cout << "The category is " << currentCategory() << endl;
			askQuestion();
		}
		else
		{
			cout << players[currentPlayer] << " is not getting out of the penalty box" << endl;
			isGettingOutOfPenaltyBox = false;
		}

	}
	else
	{

		places[currentPlayer] = places[currentPlayer] + roll;
		if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;

		cout << players[currentPlayer] << "'s new location is " << places[currentPlayer] << endl;
		cout << "The category is " << currentCategory() << endl;
		askQuestion();
	}

}

void Game::askQuestion()
{
	if (currentCategory() == "Pop")
	{
		cout << popQuestions.front() << endl;
		popQuestions.pop_front();
	}
	if (currentCategory() == "Science")
	{
		cout << scienceQuestions.front() << endl;
		scienceQuestions.pop_front();
	}
	if (currentCategory() == "Sports")
	{
		cout << sportsQuestions.front() << endl;
		sportsQuestions.pop_front();
	}
	if (currentCategory() == "Rock")
	{
		cout << rockQuestions.front() << endl;
		rockQuestions.pop_front();
	}
}


string Game::currentCategory()
{
	if (places[currentPlayer] == 0) return "Pop";
	if (places[currentPlayer] == 4) return "Pop";
	if (places[currentPlayer] == 8) return "Pop";
	if (places[currentPlayer] == 1) return "Science";
	if (places[currentPlayer] == 5) return "Science";
	if (places[currentPlayer] == 9) return "Science";
	if (places[currentPlayer] == 2) return "Sports";
	if (places[currentPlayer] == 6) return "Sports";
	if (places[currentPlayer] == 10) return "Sports";
	return "Rock";
}

bool Game::wasCorrectlyAnswered()
{
	if (inPenaltyBox[currentPlayer])
	{
		if (isGettingOutOfPenaltyBox)
		{
			cout << "Answer was correct!!!!" << endl;
			purses[currentPlayer]++;
			cout << players[currentPlayer]
			     << " now has "
			     << purses[currentPlayer]
				<<  " Gold Coins." << endl;

			bool winner = didPlayerWin();
			currentPlayer++;
			if (currentPlayer == players.size()) currentPlayer = 0;

			return winner;
		}
		else
		{
			currentPlayer++;
			if (currentPlayer == players.size()) currentPlayer = 0;
			return true;
		}



	}
	else
	{

		cout << "Answer was corrent!!!!" << endl;
		purses[currentPlayer]++;
		cout << players[currentPlayer]
				<< " now has "
				<< purses[currentPlayer]
			<< " Gold Coins." << endl;

		bool winner = didPlayerWin();
		currentPlayer++;
		if (currentPlayer == players.size()) currentPlayer = 0;

		return winner;
	}
}

bool Game::wrongAnswer()
{
	cout << "Question was incorrectly answered" << endl;
	cout << players[currentPlayer] + " was sent to the penalty box" << endl;
	inPenaltyBox[currentPlayer] = true;

	currentPlayer++;
	if (currentPlayer == players.size()) currentPlayer = 0;
	return true;
}


bool Game::didPlayerWin()
{
	return !(purses[currentPlayer] == 6);
}
