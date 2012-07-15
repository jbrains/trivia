$game = New-Object psObject -Property @{
	players = @()

	places = 0,0,0,0,0,0
	purses = 0,0,0,0,0,0

	inPenaltyBox = [bool[]](0,0,0,0,0,0)

	popQuestions = @()
	scienceQuestions = @()
	sportsQuestions = @()
	rockQuestions = @()

	currentPlayer = 0
	isGettingOutOfPenaltyBox = $false
}

function newGame {
	0..49 | % { 
		$game.popQuestions += "Pop Question " + $_
		$game.scienceQuestions += "Science Question " + $_
		$game.sportsQuestions += "Sports Question " + $_
		$game.rockQuestions += createRockQuestion $_
	}
}

function createRockQuestion($index) {
	"Rock Question " + $index
}

function isPlayable {
	(howManyPlayers) -ge 2
}

function add($playerName)
{
	$game.players += $playerName
	$game.places[(howManyPlayers)] = 0
	$game.purses[(howManyPlayers)] = 0
	$game.inPenaltyBox[(howManyPlayers)] = $false

	Write-Host $playerName "was added"
	Write-Host "They are player number" $game.players.Count
	$true
}

function howManyPlayers {
	$game.players.Count
}

function roll($roll) {
	Write-Host $game.players[$game.currentPlayer] is the current player
	Write-Host They have rolled a $roll

	if ($game.inPenaltyBox[$game.currentPlayer])
	{
		if ($roll % 2 -ne 0)
		{
			$game.isGettingOutOfPenaltyBox = $true

			Write-Host $game.players[$game.currentPlayer] is getting out of the penalty box
			$game.places[$game.currentPlayer] = $game.places[$game.currentPlayer] + $roll
			if ($game.places[$game.currentPlayer] -gt 11)  {
				$game.places[$game.currentPlayer] = $game.places[$game.currentPlayer] - 12
			}

			Write-host "$($game.players[$game.currentPlayer])'s" new location is $game.places[$game.currentPlayer]
			Write-Host The category is (currentCategory)
			askQuestion
		}
		else
		{
			Write-Host $game.players[$game.currentPlayer] is not getting out of the penalty box
			$game.isGettingOutOfPenaltyBox = $false
		}

	}
	else
	{
		$game.places[$game.currentPlayer] = $game.places[$game.currentPlayer] + $roll
		if ($game.places[$game.currentPlayer] -gt 11) {
			$game.places[$game.currentPlayer] = $game.places[$game.currentPlayer] - 12
		}

		Write-Host "$($game.players[$game.currentPlayer])'s" new location is $game.places[$game.currentPlayer]
		Write-Host The category is (currentCategory)
		askQuestion
	}
}

function askQuestion {
	if ((currentCategory) -eq "Pop")
	{
		Write-Host $game.popQuestions[0]
		$game.popQuestions = $game.popQuestions[1..$($game.popQuestions.Length-1)]
	}
	if ((currentCategory) -eq "Science")
	{
		Write-Host $game.scienceQuestions[0]
		$game.scienceQuestions = $game.scienceQuestions[1..$($game.scienceQuestions.Length-1)]
	}
	if ((currentCategory) -eq "Sports")
	{
		Write-Host $game.sportsQuestions[0]
		$game.sportsQuestions = $game.sportsQuestions[1..$($game.sportsQuestions.Length-1)]
	}
	if ((currentCategory) -eq "Rock")
	{
		Write-Host $game.rockQuestions[0]
		$game.rockQuestions = $game.rockQuestions[1..$($game.rockQuestions.Length-1)]
	}
}


function currentCategory {
	if ($game.places[$game.currentPlayer] -eq 0) { return "Pop" }
	if ($game.places[$game.currentPlayer] -eq 4) { return "Pop" }
	if ($game.places[$game.currentPlayer] -eq 8) { return "Pop" }
	if ($game.places[$game.currentPlayer] -eq 1) { return "Science" }
	if ($game.places[$game.currentPlayer] -eq 5) { return "Science" }
	if ($game.places[$game.currentPlayer] -eq 9) { return "Science" }
	if ($game.places[$game.currentPlayer] -eq 2) { return "Sports" }
	if ($game.places[$game.currentPlayer] -eq 6) { return "Sports" }
	if ($game.places[$game.currentPlayer] -eq 10) { return "Sports" }
	return "Rock"
}

function wasCorrectlyAnswered
{
	if ($game.inPenaltyBox[$game.currentPlayer])
	{
		if ($game.isGettingOutOfPenaltyBox)
		{
			Write-Host Answer was correct!!!!
			$game.purses[$game.currentPlayer]++
			Write-Host $game.players[$game.currentPlayer] now has $game.purses[$game.currentPlayer] Gold Coins.

			$winner = didPlayerWin
			$game.currentPlayer++
			if ($game.currentPlayer -eq $game.players.Count) { $game.currentPlayer = 0 }

			return $winner
		}
		else
		{
			$game.currentPlayer++
			if ($game.currentPlayer -eq $game.players.Count) { $game.currentPlayer = 0 }
			return $true
		}



	}
	else
	{

		Write-Host Answer was corrent!!!!
		$game.purses[$game.currentPlayer]++
		Write-Host $game.players[$game.currentPlayer] now has $game.purses[$game.currentPlayer] Gold Coins.

		$winner = didPlayerWin
		$game.currentPlayer++
		if ($game.currentPlayer -eq $game.players.Count) { $game.currentPlayer = 0 }

		return $winner
	}
}

function wrongAnswer {
	Write-Host Question was incorrectly answered
	Write-Host $game.players[$game.currentPlayer] was sent to the penalty box
	$game.inPenaltyBox[$game.currentPlayer] = $true

	$game.currentPlayer++
	if ($game.currentPlayer -eq $game.players.Count) { $game.currentPlayer = 0 }
	$true
}


function didPlayerWin {
	!($game.purses[$game.currentPlayer] -eq 6)
}

########################################
# run
########################################

newGame
add Chet
add Pat
add Sue

$rand = New-Object Random

do {
	roll ($rand.Next(5) + 1)

	if ($rand.Next(9) -eq 7)
	{
			$notAWinner = wrongAnswer
	}	else
	{
		$notAWinner = wasCorrectlyAnswered
	}



} while ($notAWinner)