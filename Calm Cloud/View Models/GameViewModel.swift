//
//  GameViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 9/20/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

public class GameViewModel {

    var gameMode: GameMode = .normal
    var movesLeft = 0
    var score = 0
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

    func getCurrentClouds() -> Int {
        return PlaysModel.clouds
    }

    func isInGame() -> Bool {
        return isGameInProgress
    }

    func startGame() {
        switch gameMode {
        case .normal:
            PlaysModel.clouds -= 1
            savePlays()
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

    func loadPlays() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Plays>(entityName: "Plays")

        do {
            var result = try managedContext.fetch(fetchRequest)
            if let plays = result.first {
                PlaysModel.loadedPlays = plays
                PlaysModel.clouds = Int(plays.clouds)
                PlaysModel.lastUsed = plays.lastUsed

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

        let difference = calendar.dateComponents([.minute], from: savedDate, to: Date())
        print(difference.minute)

        guard let diff = difference.minute else { return }

        if (diff / 15) >= 1 {
            // last play more than 15 minutes ago
            // credit clouds for plays, 5 at most
            var numberToAdd = min(diff/15, 5)

            if numberToAdd + PlaysModel.clouds <= 5 {
                PlaysModel.clouds += numberToAdd
            } else {
                PlaysModel.clouds = 5
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

    func savePlays() {
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
        // save last used date at four clouds, as this will be the oldest date for tracking play crediting
        if PlaysModel.clouds == 4 {
            PlaysModel.lastUsed = Date()
        }

        playsLoaded.clouds = Int16(PlaysModel.clouds)
        playsLoaded.lastUsed = PlaysModel.lastUsed

        PlaysModel.loadedPlays = playsLoaded

        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("plays not resaved")
        }
    }
}
