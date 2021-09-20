//
//  GameViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 9/20/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

public class GameViewModel {

    var gameMode: GameMode = .normal
    var movesLeft = 0
    var score = 0
    var playsLeft = 5
    var isGameInProgress = false

    enum GameMode: Int {
        case normal
        case zen
    }

    var currentLevel = GameLevel(filename: "level_1")

    func getGameLevel() -> GameLevel {
        var randomLevel = Int.random(in: 1...5)

        var level = GameLevel(filename: "level_\(randomLevel)")
        currentLevel = level
        return currentLevel
    }

    func getMode() -> GameMode {
        return gameMode
    }

    func changeMode(segment: Int) {
        gameMode = GameMode(rawValue: segment) ?? .normal
    }

    func getCurrentScore() -> String {
        return "\(score)/\(currentLevel.targetScore)"
    }

    func getCurrentMoves() -> String {
        switch gameMode {
        case .normal:
            return "\(movesLeft)"
        case .zen:
            return "∞"
        }
    }

    func getCurrentPlays() -> String {
        return "\(playsLeft)"
    }

    func isInGame() -> Bool {
        return isGameInProgress
    }

    func startGame() {
        switch gameMode {
        case .normal:
            playsLeft -= 1
            movesLeft = currentLevel.maximumMoves
            isGameInProgress = true
            score = 0
        case .zen:
            isGameInProgress = true
            score = 0
        }
    }

    func canPlayAgain() -> Bool {
        if playsLeft > 0 {
            return true
        } else {
            return false
        }
    }

    func terminateGame() {
        isGameInProgress = false
        score = 0
        movesLeft = 0
    }

    func gameOver() {
        isGameInProgress = false
    }

    func addToScore(value: Int) {
        score += value
    }

    func decreaseMoves() -> String? {
        switch gameMode {
        case .normal:
            movesLeft -= 1

            if score >= currentLevel.targetScore {
                return "Success!"
            } else if movesLeft == 0 {
                return "Fail :("
            } else {
                return nil
            }
        case .zen:
            return nil
        }
    }
}
