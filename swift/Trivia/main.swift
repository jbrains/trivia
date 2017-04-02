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

_ = aGame.add("Chet")
_ = aGame.add("Pat")
_ = aGame.add("Sue")

repeat {
    
    aGame.roll(Int(arc4random_uniform(5)) + 1)
    
    if (Int(arc4random_uniform(9)) == 7) {
        notAWinner = aGame.wrongAnswer()
    } else {
        notAWinner = aGame.wasCorrectlyAnswered()
    }
    
    
    
} while (notAWinner)
