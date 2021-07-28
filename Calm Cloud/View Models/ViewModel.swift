//
//  ViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/27/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class ViewModel {

    // MARK: Helpers
    
    func weather() {
        let day = Calendar.current.component(.day, from: Date())
        let month = Calendar.current.component(.month, from: Date())

        WeatherManager.getWeather(month: month, day: day)
    }

    func configureWeather() -> (condition: WeatherCondition, image: UIImage?) {
        // change background if night
        let hour = Calendar.current.component(.hour, from: Date())

        switch WeatherManager.currentWeather {
        case .clearWarm:
            if hour > 6 && hour < 20 {
                return (.nothing, UIImage(named: "outsidebackground"))
            } else {
                return (.nothing, UIImage(named: "outsidebackgroundnight"))
            }
        case .clearCool:
            if hour > 6 && hour < 20 {
                return (.nothing, UIImage(named: "outsidebackgroundfall"))
            } else {
                return (.nothing, UIImage(named: "outsidebackgroundfallnight"))
            }
        case .rainingWarm:
            if hour > 6 && hour < 20 {
                return (.rain, UIImage(named: "outsidebackground"))
            } else {
                return (.rain, UIImage(named: "outsidebackgroundnight"))
            }
        case .rainingCool:
            if hour > 6 && hour < 20 {
                return (.rain, UIImage(named: "outsidebackgroundfall"))
            } else {
                return (.rain, UIImage(named: "outsidebackgroundfallnight"))
            }
        case .snowing:
            if hour > 6 && hour < 20 {
                return (.snow, UIImage(named: "outsidebackgroundsnow"))
            } else {
                return (.snow, UIImage(named: "outsidebackgroundsnownight"))
            }
        case .snowOnGround:
            if hour > 6 && hour < 20 {
                return (.nothing, UIImage(named: "outsidebackgroundsnow"))
            } else {
                return (.nothing, UIImage(named: "outsidebackgroundsnownight"))
            }
        }
    }

    func getWeather() -> Weather {
        return WeatherManager.currentWeather
    }

    func isReturnedFromSegue() -> Bool {
        return StatusManager.returnedFromSegue
    }

    func setReturnFromSegue() {
        StatusManager.returnedFromSegue = true
    }

    func isRecentEnough(date: Date?, recentness: Int) -> Bool {
        if let chosenDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: chosenDate, to: Date())
            let diff = components.hour

            if let difference = diff {
                if difference < recentness {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }

    func checkFrequency(with care: Care) {
        if isRecentEnough(date: care.lastFed, recentness: 6) {
            StatusManager.hasFood = true
        }

        if isRecentEnough(date: care.lastWatered, recentness: 12) {
            StatusManager.hasWater = true
        }

        if isRecentEnough(date: care.lastCleaned, recentness: 24) {
            StatusManager.hasCleanPotty = true
        }
    }

    // MARL: Summoning

    func waterSummon() {
        StatusManager.summonedToWater = true
    }

    func foodSummon() {
        StatusManager.summonedToFood = true
    }

    func toySummon() {
        StatusManager.summonedToToy = true
    }

    func gameSummon() {
        StatusManager.summonedToGame = true
    }

    func fireSummon() {
        StatusManager.summonedToFire = true
    }

    func summonedToFood() -> Bool {
        return StatusManager.summonedToFood
    }

    func summonedToWater() -> Bool {
        return StatusManager.summonedToWater
    }

    func summonedToToy() -> Bool {
        return StatusManager.summonedToToy
    }

    func summonedToGame() -> Bool {
        return StatusManager.summonedToGame
    }

    func summonedToPotty() -> Bool {
        return StatusManager.summonedToPotty
    }

    func summonedToFire() -> Bool {
        return StatusManager.summonedToFire
    }

    func pottySummon() {
        StatusManager.summonedToPotty = true
    }

    func removeFoodSummon() {
        StatusManager.summonedToFood = false
    }

    func removeWaterSummon() {
        StatusManager.summonedToWater = false
    }

    func removeToySummon() {
        StatusManager.summonedToToy = false
    }

    func removeGameSummon() {
        StatusManager.summonedToGame = false
    }

    func removePottySummon() {
        StatusManager.summonedToPotty = false
    }

    func removeFireSummon() {
        StatusManager.summonedToFire = false
    }

    func resetSummons() {
        removeFoodSummon()
        removeWaterSummon()
        removeToySummon()
        removeGameSummon()
        removePottySummon()
        removeFireSummon()
    }

    // MARK: Care

    func hasFood() -> Bool {
        if StatusManager.hasFood {
            StatusManager.hasEaten = true
        }
        
        return StatusManager.hasFood
    }

    func hasDrunk() -> Bool {
        return StatusManager.hasDrunk
    }

    func hasEaten() -> Bool {
        return StatusManager.hasEaten
    }

    func petted() {
        StatusManager.hasBeenPet = true
    }

    func giveFood() {
        StatusManager.hasFood = true
    }

    func hasWater() -> Bool {
        if StatusManager.hasWater {
            StatusManager.hasDrunk = true
        }

        return StatusManager.hasWater
    }

    func giveWater() {
        StatusManager.hasWater = true
    }

    func hasCleanPotty() -> Bool {
        return StatusManager.hasCleanPotty
    }

    func cleanPotty() {
        StatusManager.hasCleanPotty = true
    }

    func inPotty() {
        StatusManager.inPotty = true
    }

    func isStopped() -> Bool {
        return StatusManager.stopped
    }

    // stop animations
    func stop() {
        StatusManager.stopped = true
    }

    func unStop() {
        StatusManager.stopped = false
    }

    func hasPlayed() -> Bool {
        return StatusManager.hasPlayed
    }

    func isPlaying() -> Bool {
        return StatusManager.isPlaying
    }

    func stopPlaying() {
        StatusManager.isPlaying = false
    }

    // ball track game
    func isPlayingGame() -> Bool {
        return StatusManager.playingGame
    }

    func stopPlayingGame() {
        StatusManager.playingGame = false
    }

    // MARK: Fire

    func setFireAppearance() -> UIImage? {
        if fireHasFuel() && fireHasSparkles() {
            return UIImage(named: "fireplacewoodcolor")
        } else if fireHasFuel() {
            return UIImage(named: "fireplacewood")
        } else if fireHasSparkles() {
            return UIImage(named: "fireplacecolor")
        } else {
            return UIImage(named: "fireplace")
        }
    }

    func fireHasFuel() -> Bool {
        if let validTime = Fireplace.lastsUntil {
            if validTime > Date() {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    func fireHasSparkles() -> Bool {
        if let validTime = Fireplace.color {
            if validTime > Date() {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    func isBurning() -> Bool {
        return StatusManager.fireOn
    }

    func startCrackle() {
        FireSound.startPlaying()
    }

    func turnOffFire() {
        StatusManager.fireOn = false
    }

    func turnOnFire() {
        StatusManager.fireOn = true
    }

    // MARK: Record player

    func musicOn() -> Bool {
        return StatusManager.playingMusic
    }

    func stopMusic() {
        StatusManager.playingMusic = false
    }

    func startMusic() {
        StatusManager.playingMusic = true
    }

    // MARK: Lights

    func lightsOff() -> Bool {
        return StatusManager.lightsOff
    }

    func turnLightsOff() {
        StatusManager.lightsOff = true
    }

    func turnLightsOn() {
        StatusManager.lightsOff = false
    }

    func stringLightsOn() -> Bool {
        return StatusManager.stringLightsOn
    }

    func turnStringLightsOff() {
        StatusManager.stringLightsOn = false
    }

    func turnStringLightsOn() {
        StatusManager.stringLightsOn = true
    }

    func configureLights() -> (lights: UIImage?, overlay: UIImage?) {
        if stringLightsOn() && lightsOff() {
            turnStringLightsOff()

            if stringLightsOn() && isBurning() {
                return (UIImage(named: "lights"), UIImage(named: "glowstarsfire"))
            } else if stringLightsOn() {
                return (UIImage(named: "lights"), UIImage(named: "glowstars"))
            } else if isBurning() {
                return (UIImage(named: "lights"), UIImage(named: "nostarsfire"))
            } else {
                return (UIImage(named: "lights"), UIImage(named: "nightoverlay"))
            }
        } else if stringLightsOn() == false && lightsOff() {
            turnStringLightsOn()

            if stringLightsOn() && isBurning() {
                return (UIImage(named: "lightsglow"), UIImage(named: "glowstarsfire"))
            } else if stringLightsOn() {
                return (UIImage(named: "lightsglow"), UIImage(named: "glowstars"))
            } else if isBurning() {
                return (UIImage(named: "lightsglow"), UIImage(named: "nostarsfire"))
            } else {
                return (UIImage(named: "lightsglow"), UIImage(named: "nightoverlay"))
            }
        } else {
            return (nil, nil)
        }
    }

    // MARK: Level

    func getLevel() -> String {
        return "\(LevelManager.currentLevel)"
    }

    func getLevelDetails() -> String {
        return "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
    }

    func getProgress() -> Float {
        return Float(LevelManager.currentEXP) / Float(LevelManager.maxEXP)
    }

    func canAccessLights() -> Bool {
        if LevelManager.currentLevel >= LevelManager.lightsUnlock {
            return true
        } else {
            return false
        }
    }

    func canAccessRecordPlayer() -> Bool {
        if LevelManager.currentLevel >= LevelManager.playerUnlock {
            return true
        } else {
            return false
        }
    }

    func updateEXP(source: EXPSource) -> Bool {
        // update ui with level info and save
        var amount = 0

        switch source {
        case .food, .water:
            amount = 5
        case .potty, .planting:
            amount = 10
        case .reward, .harvest:
            amount = 15
        }

        LevelManager.currentEXP += amount

        if LevelManager.currentEXP >= LevelManager.maxEXP {
            LevelManager.currentLevel += 1
            
            LevelManager.calculateLevel()

            DataFunctions.saveLevel()
            return true
        } else {
            DataFunctions.saveLevel()
            return false
        }
    }

    // MARK: Sound

    func setAmbientSound() {
        let hour = Calendar.current.component(.hour, from: Date())

        if lightsOff() {
            switch WeatherManager.currentWeather {
            case .clearWarm, .rainingWarm:
                Sound.loadSound(resourceName: Sounds.night.resourceName, type: Sounds.night.type)
                Sound.startPlaying()
            case .clearCool, .rainingCool, .snowing, .snowOnGround:
                Sound.loadSound(resourceName: Sounds.outsideFallWinterNight.resourceName, type: Sounds.outsideFallWinterNight.type)
                Sound.startPlaying()
            }
        } else {
            switch WeatherManager.currentWeather {
            case .clearWarm:
                if hour > 6 && hour < 20 {
                    Sound.loadSound(resourceName: Sounds.inside.resourceName, type: Sounds.inside.type)
                    Sound.startPlaying()
                } else {
                    Sound.loadSound(resourceName: Sounds.insideNight.resourceName, type: Sounds.insideNight.type)
                    Sound.startPlaying()
                }
            case .clearCool:
                if hour > 6 && hour < 20 {
                    Sound.loadSound(resourceName: Sounds.insideFallWinter.resourceName, type: Sounds.insideFallWinter.type)
                    Sound.startPlaying()
                } else {
                    Sound.loadSound(resourceName: Sounds.insideFallWinterNight.resourceName, type: Sounds.insideFallWinterNight.type)
                    Sound.startPlaying()
                }
            case .rainingWarm:
                Sound.loadSound(resourceName: Sounds.rainIndoors.resourceName, type: Sounds.rainIndoors.type)
                Sound.startPlaying()
            case .rainingCool:
                Sound.loadSound(resourceName: Sounds.rainIndoors.resourceName, type: Sounds.rainIndoors.type)
                Sound.startPlaying()
            case .snowing:
                if hour > 6 && hour < 20 {
                    Sound.loadSound(resourceName: Sounds.insideFallWinter.resourceName, type: Sounds.insideFallWinter.type)
                    Sound.startPlaying()
                } else {
                    Sound.loadSound(resourceName: Sounds.insideFallWinterNight.resourceName, type: Sounds.insideFallWinterNight.type)
                    Sound.startPlaying()
                }
            case .snowOnGround:
                if hour > 6 && hour < 20 {
                    Sound.loadSound(resourceName: Sounds.insideFallWinter.resourceName, type: Sounds.insideFallWinter.type)
                    Sound.startPlaying()
                } else {
                    Sound.loadSound(resourceName: Sounds.insideFallWinterNight.resourceName, type: Sounds.insideFallWinterNight.type)
                    Sound.startPlaying()
                }
            }
        }
    }

    // MARK: Money

    func getCoins() -> String {
        return "\(MoneyManager.total)"
    }

    // MARK: Animation

    func performAnimationResets(toy: UIImageView, game: UIImageView) {
        if StatusManager.returnedFromSegue {
            StatusManager.returnedFromSegue = false
        }

        if toy.isAnimating {
            toy.stopAnimating()
        }

        if StatusManager.playingGame {
            StatusManager.playingGame = false
        }

        if game.isAnimating {
            game.stopAnimating()
        }

        if StatusManager.isPlaying {
            StatusManager.isPlaying = false
        }

        if StatusManager.inPotty {
            StatusManager.inPotty = false
        }
    }

    func getMovementType() -> Movement {
        return AnimationManager.movement
    }

    func getAnimationLocation() -> Location {
        return AnimationManager.location
    }

    func stopTimer() {
        AnimationTimer.stop()
    }

    func setMood() {
        // set cloud kitty's mood deepending on activities
        if StatusManager.hasFood == false && StatusManager.hasWater == false && StatusManager.hasCleanPotty == false {
            AnimationManager.mood = .sad
        } else if StatusManager.hasEaten == true && StatusManager.hasDrunk == false {
            AnimationManager.mood = .thirsty
        } else if StatusManager.hasDrunk == true && StatusManager.hasEaten == false {
            AnimationManager.mood = .hungry
        } else if StatusManager.hasCleanPotty == false {
            AnimationManager.mood = .embarrassed
        } else if StatusManager.hasCleanPotty && StatusManager.hasFood == false && StatusManager.hasWater == false {
            AnimationManager.mood = .unhappy
        } else if (StatusManager.hasPlayed || StatusManager.hasBeenPet) && StatusManager.hasFood == false && StatusManager.hasWater == false {
            AnimationManager.mood = .unhappy
        } else if StatusManager.hasEaten && StatusManager.hasDrunk {
            AnimationManager.mood = .happy
        }
    }
}
