//
//  main.swift
//  Trivia
//
//  Created by Oliver Eikemeier on 13.10.15.
//  Copyright © 2015 Legacy Coderetreat. All rights reserved.
//

var notAWinner: Bool

let aGame = Game()

_ = aGame.add(playerName: "Chet")
_ = aGame.add(playerName: "Pat")
_ = aGame.add(playerName: "Sue")

repeat {
    
    aGame.roll(roll: Int.random(in: 1...5))
    
    if Int.random(in: 0...8) == 7 {
        notAWinner = aGame.wrongAnswer()
    } else {
        notAWinner = aGame.wasCorrectlyAnswered()
    }
    
    
    
} while (notAWinner)
