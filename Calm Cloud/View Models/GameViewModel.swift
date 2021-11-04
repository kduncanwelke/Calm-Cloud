//
//  GameViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 9/20/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum GameMode: Int {
    case normal
    case zen
}

public class GameViewModel {

    var gameMode: GameMode = .normal
    var movesLeft = 0
    var score = 0
    var isGameInProgress = false

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
        PlaysModel.mode = gameMode
    }

    func getCurrentScore() -> String {
        switch gameMode {
        case .normal:
            return "\(score)/\(currentLevel.targetScore)"
        case .zen:
            return "\(score)"
        }
    }

    func getCurrentMoves() -> String {
        switch gameMode {
        case .normal:
            return "\(movesLeft)"
        case .zen:
            return "∞"
        }
    }

    func startCloudTimer() -> Bool {
        if PlaysModel.clouds == 5 {
            return false
        } else {
            return true
        }
    }

    func isTimerRunning() -> Bool {
        if let status = CloudsTimer.timer?.isValid {
            return status
        } else {
            return false
        }
    }

    func stopTimer() {
        if let status = CloudsTimer.timer?.isValid {
            if status {
                CloudsTimer.stop()
            }
        }
    }

    func getCurrentClouds() -> Int {
        return PlaysModel.clouds
    }

    func areCloudsFull() -> Bool {
        if PlaysModel.clouds == 5 {
            return true
        } else {
            return false
        }
    }

    func isInGame() -> Bool {
        return isGameInProgress
    }

    func startGame() {
        switch gameMode {
        case .normal:
            savePlays(fromTimer: false)
            movesLeft = currentLevel.maximumMoves
            isGameInProgress = true
            score = 0
        case .zen:
            isGameInProgress = true
            score = 0
        }
    }

    func canPlayAgain() -> Bool {
        switch gameMode {
        case .normal:
            if PlaysModel.clouds > 0 {
                return true
            } else {
                return false
            }
        case .zen:
            return true
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

    func decreaseMoves() -> (image: UIImage?, won: Bool?) {
        switch gameMode {
        case .normal:
            movesLeft -= 1

            if score >= currentLevel.targetScore {
                return (UIImage(named: "winmessage"), true)
            } else if movesLeft == 0 {
                return (UIImage(named: "failuremessage"), false)
            } else {
                return (nil, nil)
            }
        case .zen:
            return (nil, nil)
        }
    }

    func giveEXP() -> Int {
        var randomPercent = Int.random(in: 10...15)

        var exp = Int(LevelManager.maxEXP/randomPercent)

        saveEXP(exp: exp)
        return exp
    }

    func giveCoins() -> Int {
        var randomCoins = Int.random(in: 1...5)

        MoneyManager.total += randomCoins
        
        DataFunctions.saveMoney()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)

        return randomCoins
    }

    func saveEXP(exp: Int) {
        LevelManager.currentEXP += exp
        print("adding \(exp) EXP")

        if LevelManager.currentEXP >= LevelManager.maxEXP {
            LevelManager.currentLevel += 1

            LevelManager.calculateLevel()

            DataFunctions.saveLevel()
        } else {
            DataFunctions.saveLevel()
        }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
    }

    func loadPlays() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Plays>(entityName: "Plays")

        do {
            var result = try managedContext.fetch(fetchRequest)
            if let plays = result.first {
                PlaysModel.loadedPlays = plays
                PlaysModel.clouds = Int(plays.clouds)
                PlaysModel.lastUsed = plays.lastUsed

                print("clouds loaded: \(PlaysModel.clouds)")

                creditPlays()
            }
            print("plays loaded")
        } catch let error as NSError {
            print("plays not loaded")
        }
    }

    func creditPlays() {
        if let savedDate = PlaysModel.lastUsed {
        // check time ellapsed since last play was used, to credit new plays every 15 minutes up, to five plays total
        let calendar = Calendar.current

        print("credit plays")
        let difference = calendar.dateComponents([.minute], from: savedDate, to: Date())
        print(difference.minute)

        guard let diff = difference.minute else { return }

        if (diff / 15) >= 1 {
            // last play more than 15 minutes ago
            // credit clouds for plays, 5 at most
            var numberToAdd = min(diff/15, 5)

            if numberToAdd + PlaysModel.clouds <= 5 {
                PlaysModel.clouds += numberToAdd
            }

            // resave
            var managedContext = CoreDataManager.shared.managedObjectContext

            guard let playsLoaded = PlaysModel.loadedPlays else { return }
                playsLoaded.clouds = Int16(PlaysModel.clouds)
                PlaysModel.loadedPlays = playsLoaded

                do {
                    try managedContext.save()
                    print("play credit resave successful")
                } catch {
                    // this should never be displayed but is here to cover the possibility
                    print("play credit not resaved")
                }
            } else {
                // not enough time has passed, do nothing
            }
        }
    }

    func savePlays(fromTimer: Bool) {
        var managedContext = CoreDataManager.shared.managedObjectContext

        // save anew if it doesn't exist (like on app initial launch)
        guard let playsLoaded = PlaysModel.loadedPlays else {
            let playsSave = Plays(context: managedContext)
            // assign date automatically, this is the first time plays are being updated
            PlaysModel.lastUsed = Date()

            playsSave.clouds = Int16(PlaysModel.clouds)
            playsSave.lastUsed = PlaysModel.lastUsed

            PlaysModel.loadedPlays = playsSave

            do {
                try managedContext.save()
                print("saved plays")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("plays not saved")
            }

            return
        }

        // otherwise rewrite data
        // if updated from timer set last used date anew so clouds aren't credited twice
        // save last used date at four clouds, as this will be the oldest date for tracking play crediting
        if fromTimer {
            if PlaysModel.clouds < 5 {
                PlaysModel.lastUsed = Date()
                PlaysModel.clouds += 1
            }
        } else {
            PlaysModel.clouds -= 1

            if PlaysModel.clouds == 4 {
                PlaysModel.lastUsed = Date()
            }
        }

        print("save info")
        print(PlaysModel.clouds)
        playsLoaded.clouds = Int16(PlaysModel.clouds)
        print(playsLoaded.clouds)
        playsLoaded.lastUsed = PlaysModel.lastUsed

        PlaysModel.loadedPlays = playsLoaded

        do {
            try managedContext.save()
            print("plays resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("plays not resaved")
        }
    }
}
