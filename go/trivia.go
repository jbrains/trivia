package main

import (
	"fmt"
	"math/rand"
	"time"
)

type Game struct {
	players      []string
	places       []int
	purses       []int
	inPenaltyBox []bool

	popQuestions     []string
	scienceQuestions []string
	sportsQuestions  []string
	rockQuestions    []string

	currentPlayer            int
	isGettingOutOfPenaltyBox bool
}

func NewGame() *Game {
	game := &Game{}
	for i := 0; i < 6; i++ {
		game.places = append(game.places, 0)
		game.purses = append(game.purses, 0)
		game.inPenaltyBox = append(game.inPenaltyBox, false)
	}

	for i := 0; i < 50; i++ {
		game.popQuestions = append(game.popQuestions,
			fmt.Sprintf("Pop Question %d\n", i))
		game.scienceQuestions = append(game.scienceQuestions,
			fmt.Sprintf("Science Question %d\n", i))
		game.sportsQuestions = append(game.sportsQuestions,
			fmt.Sprintf("Sports Question %d\n", i))
		game.rockQuestions = append(game.rockQuestions,
			game.CreateRockQuestion(i))
	}

	return game
}

func (me *Game) CreateRockQuestion(index int) string {
	return fmt.Sprintf("Rock Question %d\n", index)
}

func (me *Game) IsPlayable() bool {
	return me.howManyPlayers() >= 2
}

func (me *Game) howManyPlayers() int {
	return len(me.players)
}

func (me *Game) Add(playerName string) bool {
	me.players = append(me.players, playerName)
	me.places[me.howManyPlayers()] = 0
	me.purses[me.howManyPlayers()] = 0
	me.inPenaltyBox[me.howManyPlayers()] = false

	fmt.Printf("%s was added\n", playerName)
	fmt.Printf("They are player number %d\n", len(me.players))

	return true
}

func (me *Game) Roll(roll int) {
	fmt.Printf("%s is the current player\n", me.players[me.currentPlayer])
	fmt.Printf("They have rolled a %d\n", roll)

	if me.inPenaltyBox[me.currentPlayer] {
		if roll%2 != 0 {
			me.isGettingOutOfPenaltyBox = true

			fmt.Printf("%s is getting out of the penalty box\n", me.players[me.currentPlayer])
			me.places[me.currentPlayer] = me.places[me.currentPlayer] + roll
			if me.places[me.currentPlayer] > 11 {
				me.places[me.currentPlayer] = me.places[me.currentPlayer] - 12
			}

			fmt.Printf("%s's new location is %d\n", me.players[me.currentPlayer], me.places[me.currentPlayer])
			fmt.Printf("The category is %s\n", me.currentCategory())
			me.askQuestion()
		} else {
			fmt.Printf("%s is not getting out of the penalty box\n", me.players[me.currentPlayer])
			me.isGettingOutOfPenaltyBox = false
		}
	} else {
		me.places[me.currentPlayer] = me.places[me.currentPlayer] + roll
		if me.places[me.currentPlayer] > 11 {
			me.places[me.currentPlayer] = me.places[me.currentPlayer] - 12
		}

		fmt.Printf("%s's new location is %d\n", me.players[me.currentPlayer], me.places[me.currentPlayer])
		fmt.Printf("The category is %s\n", me.currentCategory())
		me.askQuestion()
	}
}

func (me *Game) askQuestion() {
	if me.currentCategory() == "Pop" {
		question := me.popQuestions[0]
		me.popQuestions = me.popQuestions[1:]
		fmt.Printf(question)
	}
	if me.currentCategory() == "Science" {
		question := me.scienceQuestions[0]
		me.scienceQuestions = me.scienceQuestions[1:]
		fmt.Printf(question)
	}
	if me.currentCategory() == "Sports" {
		question := me.sportsQuestions[0]
		me.sportsQuestions = me.sportsQuestions[1:]
		fmt.Printf(question)
	}
	if me.currentCategory() == "Rock" {
		question := me.rockQuestions[0]
		me.rockQuestions = me.rockQuestions[1:]
		fmt.Printf(question)
	}
}

func (me *Game) currentCategory() string {
	if me.places[me.currentPlayer] == 0 {
		return "Pop"
	}
	if me.places[me.currentPlayer] == 4 {
		return "Pop"
	}
	if me.places[me.currentPlayer] == 8 {
		return "Pop"
	}
	if me.places[me.currentPlayer] == 1 {
		return "Science"
	}
	if me.places[me.currentPlayer] == 5 {
		return "Science"
	}
	if me.places[me.currentPlayer] == 9 {
		return "Science"
	}
	if me.places[me.currentPlayer] == 2 {
		return "Sports"
	}
	if me.places[me.currentPlayer] == 6 {
		return "Sports"
	}
	if me.places[me.currentPlayer] == 10 {
		return "Sports"
	}
	return "Rock"
}

func (me *Game) WasCorrectlyAnswered() bool {
	if me.inPenaltyBox[me.currentPlayer] {
		if me.isGettingOutOfPenaltyBox {
			fmt.Println("Answer was correct!!!!")
			me.purses[me.currentPlayer] += 1
			fmt.Printf("%s now has %d Gold Coins.\n", me.players[me.currentPlayer], me.purses[me.currentPlayer])

			winner := me.didPlayerWin()
			me.currentPlayer += 1
			if me.currentPlayer == len(me.players) {
				me.currentPlayer = 0
			}

			return winner
		} else {
			me.currentPlayer += 1
			if me.currentPlayer == len(me.players) {
				me.currentPlayer = 0
			}
			return true
		}
	} else {

		fmt.Println("Answer was corrent!!!!")
		me.purses[me.currentPlayer] += 1
		fmt.Printf("%s now has %d Gold Coins.\n", me.players[me.currentPlayer], me.purses[me.currentPlayer])

		winner := me.didPlayerWin()
		me.currentPlayer += 1
		if me.currentPlayer == len(me.players) {
			me.currentPlayer = 0
		}

		return winner
	}

	return false
}

func (me *Game) didPlayerWin() bool {
	return !(me.purses[me.currentPlayer] == 6)
}

func (me *Game) WrongAnswer() bool {
	fmt.Println("Question was incorrectly answered")
	fmt.Printf("%s was sent to the penalty box\n", me.players[me.currentPlayer])
	me.inPenaltyBox[me.currentPlayer] = true

	me.currentPlayer += 1
	if me.currentPlayer == len(me.players) {
		me.currentPlayer = 0
	}

	return true
}

func main() {
	notAWinner := false

	game := NewGame()

	game.Add("Chet")
	game.Add("Pat")
	game.Add("Sue")

	rand.Seed(time.Now().UTC().UnixNano())

	for {
		game.Roll(rand.Intn(5) + 1)

		if rand.Intn(9) == 7 {
			notAWinner = game.WrongAnswer()
		} else {
			notAWinner = game.WasCorrectlyAnswered()

		}

		if !notAWinner {
			break
		}
	}
}
