/**\file
 *  FILE DESCRIPTION
 *  --------------------------------------------------------------------------
 *  File name: Game.h
 *
 *  Short Description:
 *  Declaration of Game class.
 */

/*============================================================================*\
 * PREPROCESSOR DIRECTIVES
\*============================================================================*/

/* INCLUDE DIRECTIVES FOR STANDARD HEADERS -----------------------------------*/

#include <iostream>
#include <list>
#include <vector>

/* INCLUDE DIRECTIVES FOR OTHER HEADERS --------------------------------------*/

/* HEADER GUARD --------------------------------------------------------------*/

#ifndef GAME_H_
#define GAME_H_

/*============================================================================*\
 * NAMESPACES
\*============================================================================*/

namespace game {

/*============================================================================*\
 * FILE SCOPE DECLARATIONS AND DEFINITIONS
\*============================================================================*/

/* CONSTANTS -----------------------------------------------------------------*/

/* ENUMS ---------------------------------------------------------------------*/

/* STRUCTS -------------------------------------------------------------------*/

/* OTHER TYPEDEFS ------------------------------------------------------------*/

/*============================================================================*\
 * MEMBER FUNCTION DECLARATIONS
\*============================================================================*/

class Game{
public:
	Game();
	~Game();

	void add(std::string playerName);
	void roll(unsigned int roll);
	bool wasCorrectlyAnswered();
    void wrongAnswer();

private:
    void createQuestions();
    bool isPlayable();
    unsigned int howManyPlayers();
    void askQuestion();
    std::string currentCategory();
	bool didPlayerWin();

	std::vector<std::string> players;

    unsigned int places[6U];
    unsigned int purses[6U];

    bool inPenaltyBox[6U];

    std::list<std::string> popQuestions;
    std::list<std::string> scienceQuestions;
    std::list<std::string> sportsQuestions;
    std::list<std::string> rockQuestions;

    unsigned int currentPlayer;
    bool isGettingOutOfPenaltyBox;

protected:
};

} // game namespace

/* END OF HEADER GUARD -------------------------------------------------------*/

#endif /* GAME_H_ */

/*============================================================================*\
 * END OF FILE
\*============================================================================*/
