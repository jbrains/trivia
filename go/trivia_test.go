package main

import (
	"fmt"
	"testing"
)

func TestGameWinner(t *testing.T) {
    winner := "Chet"
	notAWinner := false

	game := NewGame()

	game.Add("Chet")
	game.Add("Pat")
	game.Add("Sue")

    FixedVal := 5
	for {
		game.Roll(FixedVal)
		//test only correct answers
		notAWinner = game.WasCorrectlyAnswered()

		if !notAWinner {
			fmt.Printf("%s won\n", game.players[game.currentPlayer - 1])
			break
		}
	}
	if winner != game.players[game.currentPlayer - 1] {
		t.Errorf(" Expected \"%s\", but got \" %s\" ", game.players[game.currentPlayer - 1], winner)
	}

}

func TestGameWinnerWrongAnswers(t *testing.T) {
    winner := "Chet"
	notAWinner := false

	game := NewGame()

	game.Add("Chet")
	game.Add("Pat")
	game.Add("Sue")

    FixedVal := 5
	for {
		game.Roll(FixedVal)
		//test only wrong answers
		notAWinner = game.WrongAnswer()

		if !notAWinner {
			fmt.Printf("%s won\n", game.players[game.currentPlayer - 1])
			break
		}
	}
	//expect out of range error
}
