#include "Game.h"
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>

using namespace std;

Game::Game(ostream& output) : places{}, purses{}, currentPlayer(0), output(output){
	for (int i = 0; i < 50; i++)
	{
		ostringstream oss (ostringstream::out);
		oss << "Pop Question " << i;

		popQuestions.push_back(oss.str());

		ostringstream scienceOss (ostringstream::out);
		scienceOss << "Science Question " << i;
		scienceQuestions.push_back(scienceOss.str());

		ostringstream sportsOss (ostringstream::out);
		sportsOss << "Sports Question " << i;
		sportsQuestions.push_back(sportsOss.str());

		rockQuestions.push_back(createRockQuestion(i));
	}
}

string Game::createRockQuestion(int index)
{
	ostringstream oss (ostringstream::out);
	oss << "Rock Question " << index;
	return oss.str();
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

	output << playerName << " was added" << endl;
	output << "They are player number " << players.size() << endl;
	return true;
}

int Game::howManyPlayers()
{
	return players.size();
}

void Game::roll(int roll)
{
	output << players[currentPlayer] << " is the current player" << endl;
	output << "They have rolled a " << roll << endl;

	if (inPenaltyBox[currentPlayer])
	{
		if (roll % 2 != 0)
		{
			isGettingOutOfPenaltyBox = true;

			output << players[currentPlayer] << " is getting out of the penalty box" << endl;
			places[currentPlayer] = places[currentPlayer] + roll;
			if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;

			output << players[currentPlayer] << "'s new location is " << places[currentPlayer] << endl;
			output << "The category is " << currentCategory() << endl;
			askQuestion();
		}
		else
		{
			output << players[currentPlayer] << " is not getting out of the penalty box" << endl;
			isGettingOutOfPenaltyBox = false;
		}

	}
	else
	{

		places[currentPlayer] = places[currentPlayer] + roll;
		if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;

		output << players[currentPlayer] << "'s new location is " << places[currentPlayer] << endl;
		output << "The category is " << currentCategory() << endl;
		askQuestion();
	}

}

void Game::askQuestion()
{
	if (currentCategory() == "Pop")
	{
		output << popQuestions.front() << endl;
		popQuestions.pop_front();
	}
	if (currentCategory() == "Science")
	{
		output << scienceQuestions.front() << endl;
		scienceQuestions.pop_front();
	}
	if (currentCategory() == "Sports")
	{
		output << sportsQuestions.front() << endl;
		sportsQuestions.pop_front();
	}
	if (currentCategory() == "Rock")
	{
		output << rockQuestions.front() << endl;
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
			output << "Answer was correct!!!!" << endl;
			purses[currentPlayer]++;
			output << players[currentPlayer]
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

		output << "Answer was corrent!!!!" << endl;
		purses[currentPlayer]++;
		output << players[currentPlayer]
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
	output << "Question was incorrectly answered" << endl;
	output << players[currentPlayer] + " was sent to the penalty box" << endl;
	inPenaltyBox[currentPlayer] = true;

	currentPlayer++;
	if (currentPlayer == players.size()) currentPlayer = 0;
	return true;
}


bool Game::didPlayerWin()
{
	return !(purses[currentPlayer] == 6);
}