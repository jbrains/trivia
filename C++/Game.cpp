/**\file
 *  FILE DESCRIPTION
 *  --------------------------------------------------------------------------
 *  File name: Game.cpp
 *
 *  Short Description:
 *  Implementation of Game class.
 */

/*============================================================================*\
 * PREPROCESSOR DIRECTIVES
\*============================================================================*/

/* INCLUDE DIRECTIVES FOR STANDARD HEADERS -----------------------------------*/

#include <sstream>

/* INCLUDE DIRECTIVES FOR OTHER HEADERS --------------------------------------*/

#include "Game.h"

/*============================================================================*\
 * NAMESPACES
\*============================================================================*/

namespace game{

/*============================================================================*\
 * FILE SCOPE DECLARATIONS AND DEFINITIONS
\*============================================================================*/

/* CONSTANTS -----------------------------------------------------------------*/

/* ENUMS ---------------------------------------------------------------------*/

/* STRUCTS -------------------------------------------------------------------*/

/* OTHER TYPEDEFS ------------------------------------------------------------*/

/*============================================================================*\
 * NON-MEMBER FUNCTION DEFINITIONS
\*============================================================================*/

/*============================================================================*\
 * MEMBER FUNCTION DEFINITIONS
\*============================================================================*/

/**
Constructor of Game  class.
- Functions:
 - Initialize the member variables.
 - Call the method which creates the questions.
 .
.
\n
*/
Game::Game():
    places{0U},
    purses{0U},
    inPenaltyBox{false},
    currentPlayer(0U),
    isGettingOutOfPenaltyBox(false)
{
	createQuestions();
}

/**
Destructor of Conversion class.
.
*/
Game::~Game(){}

/**
 - Input parameters:
  - None
 - Return parameter:
  - None
 - Functions:
  - It creates fifty question in all category.
*/
void Game::createQuestions()
{
	for (unsigned int i = 1U; i <= 50U; i++)
	{
		std::ostringstream oss (std::ostringstream::out);

		oss << "Pop Question " << i;
		popQuestions.push_back(oss.str());

		oss.str("");
        oss.clear();
		oss << "Science Question " << i;
		scienceQuestions.push_back(oss.str());

		oss.str("");
        oss.clear();
		oss << "Sports Question " << i;
		sportsQuestions.push_back(oss.str());

		oss.str("");
        oss.clear();
		oss << "Rock Question " << i;
		rockQuestions.push_back(oss.str());
	}
}

/**
 - Input parameters:
  - None
 - Return parameter:
  - It returns true value if the player number greater or equal with 2.
 - Functions:
  - It chooses the game playable or not.
*/
bool Game::isPlayable()
{
	return (2U <= howManyPlayers());
}

/**
 - Input parameters:
  - playerName: contains the name of the new player.
 - Return parameter:
  - None
 - Functions:
  - Add the new player to the players vector.
  - Initiate its places and purses and reset the penalty box of the player.
*/
void Game::add(std::string playerName)
{
	players.push_back(playerName);
	places[howManyPlayers()] = 0U;
	purses[howManyPlayers()] = 0U;
	inPenaltyBox[howManyPlayers()] = false;

	std::cout << playerName << " was added" << std::endl;
	std::cout << "They are player number " << players.size() << std::endl;
	if (isPlayable())
    {
        std::cout << "The minimum player number is reached, the game is playable" << std::endl;
    }
    else
    {
        std::cout << "Need more player" << std::endl;
    }
}

/**
 - Input parameters:
  - None
 - Return parameter:
  - It returns with the number of the players.
 - Functions:
  - It checks the number of the players and return with this value.
*/
unsigned int Game::howManyPlayers()
{
	return players.size();
}

/**
 - Input parameters:
  - roll: The value of the actual roll.
 - Return parameter:
  - None
 - Functions:
  - If the current player is in penalty box and if the roll is odd the player get out from the penalty box.
  - If the player get out from penalty box or not was there ask new question from the player and set new place of player.
  - If the player new place bigger the 11 decrease it with 12.
  */
void Game::roll(unsigned int roll)
{
	std::cout << players[currentPlayer] << " is the current player" << std::endl;
	std::cout << "They have rolled a " << roll << std::endl;

	if (inPenaltyBox[currentPlayer])
	{
		if (0U != roll % 2U)
		{
			isGettingOutOfPenaltyBox = true;

			std::cout << players[currentPlayer] << " is getting out of the penalty box" << std::endl;
			places[currentPlayer] = places[currentPlayer] + roll;
			if (places[currentPlayer] > 11U)
            {
                places[currentPlayer] = places[currentPlayer] - 12U;
            }
            else
            {
                /* Do nothing */
            }
			std::cout << players[currentPlayer] << "'s new location is " << places[currentPlayer] << std::endl;
			std::cout << "The category is " << currentCategory() << std::endl;
			askQuestion();
		}
		else
		{
			std::cout << players[currentPlayer] << " is not getting out of the penalty box" << std::endl;
			isGettingOutOfPenaltyBox = false;
		}

	}
	else
	{

		places[currentPlayer] = places[currentPlayer] + roll;
		if (places[currentPlayer] > 11U)
        {
            places[currentPlayer] = places[currentPlayer] - 12U;
        }
        else
        {
            /* Do nothing */
        }
		std::cout << players[currentPlayer] << "'s new location is " << places[currentPlayer] << std::endl;
		std::cout << "The category is " << currentCategory() << std::endl;
		askQuestion();
	}

}

/**
 - Input parameters:
  - None
 - Return parameter:
  - None
 - Functions:
  - Based on the current category ask new question from the actual player.
*/
void Game::askQuestion()
{
	if ("Pop" == currentCategory())
	{
		std::cout << popQuestions.front() << std::endl;
		popQuestions.pop_front();
	}
	else if ("Science" == currentCategory())
	{
		std::cout << scienceQuestions.front() << std::endl;
		scienceQuestions.pop_front();
	}
	else if ("Sports" == currentCategory())
	{
		std::cout << sportsQuestions.front() << std::endl;
		sportsQuestions.pop_front();
	}
	else if ("Rock" == currentCategory())
	{
		std::cout << rockQuestions.front() << std::endl;
		rockQuestions.pop_front();
	}
	else
    {
        /* Do nothing */
    }
}

/**
 - Input parameters:
  - None
 - Return parameter:
  - It returns with the current category.
 - Functions:
  - Return with the new category based on the actual location of the player.
*/
std::string Game::currentCategory()
{
    std::string ret = "";
    switch (places[currentPlayer])
    {
        case 0U:
        case 4U:
        case 8U:
        {
            ret = "Pop";
            break;
        }
        case 1U:
        case 5U:
        case 9U:
        {
            ret = "Science";
            break;
        }
        case 2U:
        case 6U:
        case 10U:
        {
            ret = "Sports";
            break;
        }
        default:
        {
            ret = "Rock";
        }
    }
	return ret;
}

/**
 - Input parameters:
  - None
 - Return parameter:
  - None
 - Functions:
  - If the answer was incorrect this method print it to the console.
  - It sends the player to the penalty box and if the turn is over it reset the current player index.
*/
bool Game::wasCorrectlyAnswered()
{
    bool notwinner = true;
	if (inPenaltyBox[currentPlayer])
	{
		if (isGettingOutOfPenaltyBox)
		{
		    inPenaltyBox[currentPlayer] = false;
			std::cout << "Answer was correct!!!!" << std::endl;
			purses[currentPlayer]++;
			std::cout << players[currentPlayer]
                << " now has "
                << purses[currentPlayer]
				<<  " Gold Coins." << std::endl;

			notwinner = didPlayerWin();
			currentPlayer++;
			if (currentPlayer == players.size())
            {
                currentPlayer = 0U;
            }
            else
            {
                /* Do nothing */
            }
		}
		else
		{
			currentPlayer++;
			if (currentPlayer == players.size())
            {
                currentPlayer = 0U;
            }
            else
            {
                /* Do nothing */
            }
			notwinner = true;
		}



	}
	else
	{

		std::cout << "Answer was corrent!!!!" << std::endl;
		purses[currentPlayer]++;
		std::cout << players[currentPlayer]
            << " now has "
            << purses[currentPlayer]
			<< " Gold Coins." << std::endl;

		notwinner = didPlayerWin();
		currentPlayer++;
		if (currentPlayer == players.size())
        {
            currentPlayer = 0U;
        }
        else
        {
            /* Do nothing */
        }
	}
	return notwinner;
}

/**
 - Input parameters:
  - None
 - Return parameter:
  - None
 - Functions:
  - If the answer was incorrect this method print it to the console.
  - It sends the player to the penalty box and if the turn is over it reset the current player index.
*/
void Game::wrongAnswer()
{
	std::cout << "Question was incorrectly answered" << std::endl;
	std::cout << players[currentPlayer] + " was sent to the penalty box" << std::endl;
	inPenaltyBox[currentPlayer] = true;

	currentPlayer++;
	if (currentPlayer == players.size())
    {
        currentPlayer = 0U;
    }
    else
    {
        /* Do nothing */
    }
}

/**
 - Input parameters:
  - None
 - Return parameter:
  - If there is a winner it returns with false value.
 - Functions:
  - The method check there is a winner or not.
*/
bool Game::didPlayerWin()
{
    bool notwinner = false;
    if (6U == purses[currentPlayer])
    {
        std::cout << players[currentPlayer] + " is the winner." << std::endl;
    }
    else
    {
        notwinner = true;
    }

	return notwinner;
}

} // game namespace

/*============================================================================*\
 * END OF FILE
\*============================================================================*/
