//
//  MiniGameViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/4/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class MiniGameViewModel {

    var correctPot = 0
    var selection = 0
    var gameEnded = false

    func randomNumber() {
        let number = Int.random(in: 1...3)
        correctPot = number
    }

    func setForNewRound() {
        gameEnded = false
        randomNumber()
    }

    func isGameNotEnded() -> Bool {
        if gameEnded {
            return true
        } else {
            return false
        }
    }

    func setSelected(number: Int) {
        selection = number
    }

    func getPotImage() -> (win: Bool, image: UIImage?) {
        if selection == correctPot {
            return (true, UIImage(named: "snailpot"))
        } else {
            return (false, UIImage(named: "potnosnail"))
        }
    }

    func endGame() {
        gameEnded = true
    }

    func randomCoinReward() -> Int? {
        let chance = Int.random(in: 1...20)

        // 1 in 10 chance of getting reward
        if chance == 7 {
            return Int.random(in: 1...5)
        } else {
            return nil
        }
    }

    func addReward() -> Bool {
        if let reward = randomCoinReward() {
            MoneyManager.total += reward
            return true
        } else {
            return false
        }
    }
}
