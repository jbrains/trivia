module Game exposing (Game, add, init, roll, wasCorrectlyAnswered, wrongAnswer)

import Array exposing (Array)


type alias Game =
    { players : Array String
    , places : Array Int
    , purses : Array Int
    , inPenaltyBox : Array Bool
    , popQuestions : Array String
    , scienceQuestions : Array String
    , sportsQuestions : Array String
    , rockQuestions : Array String
    , currentPlayer : Int
    , isGettingOutOfPenaltyBox : Bool
    }


init : ( Game, List String )
init =
    ( List.range 0 49
        |> List.foldl
            (\i this ->
                { this
                    | popQuestions = Array.push ("Pop Question " ++ String.fromInt i) this.popQuestions
                    , scienceQuestions = Array.push ("Science Question " ++ String.fromInt i) this.scienceQuestions
                    , sportsQuestions = Array.push ("Sports Question " ++ String.fromInt i) this.sportsQuestions
                    , rockQuestions = Array.push (createRockQuestion i) this.rockQuestions
                }
            )
            { players = Array.empty
            , places = Array.repeat 6 0
            , purses = Array.repeat 6 0
            , inPenaltyBox = Array.repeat 6 False
            , popQuestions = Array.empty
            , scienceQuestions = Array.empty
            , sportsQuestions = Array.empty
            , rockQuestions = Array.empty
            , currentPlayer = 0
            , isGettingOutOfPenaltyBox = False
            }
    , []
    )


createRockQuestion : Int -> String
createRockQuestion i =
    "Rock Question " ++ String.fromInt i


isPlayable : Game -> Bool
isPlayable this =
    howManyPlayers this >= 2


add : String -> Game -> ( Game, List String )
add playerName this =
    let
        newGame =
            { this
                | players = Array.push playerName this.players
                , places = Array.set (howManyPlayers this) 0 this.places
                , purses = Array.set (howManyPlayers this) 0 this.purses
                , inPenaltyBox = Array.set (howManyPlayers this) False this.inPenaltyBox
            }
    in
    ( newGame
    , [ playerName ++ " was added"
      , "They are player number " ++ String.fromInt (Array.length newGame.players)
      ]
    )


howManyPlayers : Game -> Int
howManyPlayers game =
    Array.length game.players


roll : Int -> Game -> ( Game, List String )
roll roll_ this =
    let
        initialLogs =
            [ getUnsafe this.players this.currentPlayer ++ " is the current player"
            , "They have rolled a " ++ String.fromInt roll_
            ]

        ( next, logs ) =
            if getUnsafe this.inPenaltyBox this.currentPlayer then
                if modBy 2 roll_ /= 0 then
                    let
                        next_ =
                            { this
                                | isGettingOutOfPenaltyBox = True
                                , places = Array.set this.currentPlayer (getUnsafe this.places this.currentPlayer + roll_) this.places
                                , inPenaltyBox = Array.set this.currentPlayer False this.inPenaltyBox
                            }

                        next__ =
                            if getUnsafe next_.places this.currentPlayer > 11 then
                                { next_ | places = Array.set this.currentPlayer (getUnsafe next_.places this.currentPlayer - 12) next_.places }

                            else
                                next_

                        ( next___, askLogs ) =
                            askQuestion next__
                    in
                    ( next___
                    , [ getUnsafe this.players this.currentPlayer ++ " is getting out of the penalty box"
                      , getUnsafe next__.players next__.currentPlayer ++ "'s new location is " ++ String.fromInt (getUnsafe next__.places next__.currentPlayer)
                      , "The category is " ++ currentCategory next__
                      ]
                        ++ askLogs
                    )

                else
                    ( { this
                        | isGettingOutOfPenaltyBox = False
                      }
                    , [ getUnsafe this.players this.currentPlayer ++ " is not getting out of the penalty box" ]
                    )

            else
                let
                    next_ =
                        { this
                            | places = Array.set this.currentPlayer (getUnsafe this.places this.currentPlayer + roll_) this.places
                        }

                    next__ =
                        if getUnsafe next_.places this.currentPlayer > 11 then
                            { next_ | places = Array.set this.currentPlayer (getUnsafe next_.places this.currentPlayer - 12) next_.places }

                        else
                            next_

                    ( next___, askLogs ) =
                        askQuestion next__
                in
                ( next___
                , [ getUnsafe next__.players next__.currentPlayer ++ "'s new location is " ++ String.fromInt (getUnsafe next__.places next__.currentPlayer)
                  , "The category is " ++ currentCategory next__
                  ]
                    ++ askLogs
                )
    in
    ( next, initialLogs ++ logs )


askQuestion : Game -> ( Game, List String )
askQuestion game =
    let
        ( popNext, popLogs ) =
            if currentCategory game == "Pop" then
                ( { game | popQuestions = removeFirst game.popQuestions }
                , [ Array.get 0 game.popQuestions
                        |> Maybe.withDefault "--- out of Pop questions ---"
                  ]
                )

            else
                ( game, [] )

        ( scienceNext, scienceLogs ) =
            if currentCategory popNext == "Science" then
                ( { popNext | scienceQuestions = removeFirst popNext.scienceQuestions }
                , [ Array.get 0 popNext.scienceQuestions
                        |> Maybe.withDefault "--- out of Science questions ---"
                  ]
                )

            else
                ( popNext, [] )

        ( sportsNext, sportsLogs ) =
            if currentCategory scienceNext == "Sports" then
                ( { scienceNext | sportsQuestions = removeFirst scienceNext.sportsQuestions }
                , [ Array.get 0 scienceNext.sportsQuestions
                        |> Maybe.withDefault "--- out of Sports questions ---"
                  ]
                )

            else
                ( scienceNext, [] )

        ( rockNext, rockLogs ) =
            if currentCategory sportsNext == "Rock" then
                ( { sportsNext | rockQuestions = removeFirst sportsNext.rockQuestions }
                , [ Array.get 0 sportsNext.rockQuestions
                        |> Maybe.withDefault "--- out of Rock questions ---"
                  ]
                )

            else
                ( sportsNext, [] )
    in
    ( rockNext
    , popLogs ++ scienceLogs ++ sportsLogs ++ rockLogs
    )


currentCategory : Game -> String
currentCategory this =
    if getUnsafe this.places this.currentPlayer == 0 then
        "Pop"

    else if getUnsafe this.places this.currentPlayer == 4 then
        "Pop"

    else if getUnsafe this.places this.currentPlayer == 8 then
        "Pop"

    else if getUnsafe this.places this.currentPlayer == 1 then
        "Science"

    else if getUnsafe this.places this.currentPlayer == 5 then
        "Science"

    else if getUnsafe this.places this.currentPlayer == 9 then
        "Science"

    else if getUnsafe this.places this.currentPlayer == 2 then
        "Sports"

    else if getUnsafe this.places this.currentPlayer == 6 then
        "Sports"

    else if getUnsafe this.places this.currentPlayer == 10 then
        "Sports"

    else
        "Rock"


wasCorrectlyAnswered : Game -> ( Bool, Game, List String )
wasCorrectlyAnswered this =
    if getUnsafe this.inPenaltyBox this.currentPlayer then
        if this.isGettingOutOfPenaltyBox then
            let
                next =
                    { this | purses = Array.set this.currentPlayer (getUnsafe this.purses this.currentPlayer + 1) this.purses }

                winner =
                    didPlayerWin next

                next_ =
                    { next
                        | currentPlayer = next.currentPlayer + 1
                    }

                next__ =
                    if next_.currentPlayer == Array.length next_.players then
                        { next_ | currentPlayer = 0 }

                    else
                        next_
            in
            ( winner
            , next__
            , [ "Answer was corrent!!!!"
              , getUnsafe next.players next.currentPlayer ++ " now has " ++ String.fromInt (getUnsafe next.purses next.currentPlayer) ++ " Gold Coins."
              ]
            )

        else
            let
                next =
                    { this
                        | currentPlayer = this.currentPlayer + 1
                    }

                next_ =
                    if next.currentPlayer == Array.length next.players then
                        { next | currentPlayer = 0 }

                    else
                        next
            in
            ( True
            , next_
            , []
            )

    else
        let
            next =
                { this | purses = Array.set this.currentPlayer (getUnsafe this.purses this.currentPlayer + 1) this.purses }

            winner =
                didPlayerWin next

            next_ =
                { next
                    | currentPlayer = next.currentPlayer + 1
                }

            next__ =
                if next_.currentPlayer == Array.length next_.players then
                    { next_ | currentPlayer = 0 }

                else
                    next_
        in
        ( winner
        , next__
        , [ "Answer was corrent!!!!"
          , getUnsafe next.players next.currentPlayer ++ " now has " ++ String.fromInt (getUnsafe next.purses next.currentPlayer) ++ " Gold Coins."
          ]
        )


wrongAnswer : Game -> ( Bool, Game, List String )
wrongAnswer this =
    let
        next =
            { this
                | inPenaltyBox = Array.set this.currentPlayer True this.inPenaltyBox
                , currentPlayer = this.currentPlayer + 1
            }

        next_ =
            if next.currentPlayer == Array.length next.players then
                { next | currentPlayer = 0 }

            else
                next
    in
    ( True
    , next_
    , [ "Question was incorrectly answered"
      , getUnsafe this.players this.currentPlayer ++ " was sent to the penalty box"
      ]
    )


didPlayerWin : Game -> Bool
didPlayerWin this =
    not (getUnsafe this.purses this.currentPlayer == 6)



-- Utilities to make the Array API more like imperative code
-- You _should_ clean these up


removeFirst : Array a -> Array a
removeFirst array =
    Array.slice 1 (Array.length array) array


getUnsafe : Array a -> Int -> a
getUnsafe arr index =
    case Array.get index arr of
        Nothing ->
            Debug.todo <| "Out of boundary: " ++ String.fromInt index ++ " out of " ++ String.fromInt (Array.length arr)

        Just e ->
            e
