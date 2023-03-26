//
//  main.swift
//  Trivia
//
//  Created by Oliver Eikemeier on 13.10.15.
//  Copyright © 2015 Legacy Coderetreat. All rights reserved.
//

import Foundation

var notAWinner: Bool

let aGame = Game()

_ = aGame.add(playerName: "Chet")
_ = aGame.add(playerName: "Pat")
_ = aGame.add(playerName: "Sue")

repeat {
    
    aGame.roll(roll: Int(arc4random_uniform(5)) + 1)
    
    if (Int(arc4random_uniform(9)) == 7) {
        notAWinner = aGame.wrongAnswer()
    } else {
        notAWinner = aGame.wasCorrectlyAnswered()
    }
    
    
    
} while (notAWinner)
