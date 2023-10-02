module Main exposing (main, run)

import Game exposing (Game)
import Html exposing (Html, div, p, text)
import Random exposing (Seed)


main : Html msg
main =
    view run


run : List String
run =
    let
        ( game, initialLogs ) =
            Game.init
                |> andThen (Game.add "Chet")
                |> andThen (Game.add "Pat")
                |> andThen (Game.add "Sue")
    in
    go game initialLogs (Random.initialSeed 0)


go : Game -> List String -> Seed -> List String
go game queue seed =
    let
        ( upToFive, seed_ ) =
            Random.step (Random.int 1 5) seed

        ( upToEight, seed__ ) =
            Random.step (Random.int 0 8) seed_

        ( game_, rollLogs ) =
            Game.roll (upToFive + 1) game

        ( notAWinner, game__, answerLogs ) =
            if upToEight == 7 then
                Game.wrongAnswer game_

            else
                Game.wasCorrectlyAnswered game_

        nextGame =
            game__

        nextQueue =
            queue ++ rollLogs ++ answerLogs

        nextSeed =
            seed__
    in
    if notAWinner then
        go nextGame nextQueue nextSeed

    else
        nextQueue


view : List String -> Html msg
view games =
    games
        |> List.map (\line -> p [] [ text line ])
        |> div []



-- This part is used to collect the logs, you can ignore it


andThen : (a -> ( b, List String )) -> ( a, List String ) -> ( b, List String )
andThen f ( x, xlog ) =
    let
        ( fx, fxlog ) =
            f x
    in
    ( fx, xlog ++ fxlog )
