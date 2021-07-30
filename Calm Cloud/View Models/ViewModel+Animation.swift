//
//  ViewModel+Animation.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/29/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension ViewModel {

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

    func respondToActivity(activity: Behavior) {
        switch activity {
            case .play:
                StatusManager.hasPlayed = true
                StatusManager.playingGame = true
            case .eat:
                StatusManager.hasEaten = true
            case .drink:
                StatusManager.hasDrunk = true
        }

        setMood()
    }

    func randomMovementAnimation() -> Animation {
        var move = Random.randomChance()

        var animations: [Animation] = [.sleep]

        if move {
            switch AnimationManager.location {
            case .bed:
                animations = [.moveRightToWater, .moveRightToFood, .moveRightToToy, .moveRightToCenter]
                return animations.randomElement() ?? .moveRightToWater
            case .food:
                animations = [.moveLeftToWater, .moveLeftToBed, .moveRightToPillow, .moveLeftToCenter]
                return animations.randomElement() ?? .moveLeftToWater
            case .water:
                animations = [.moveRightToFood, .moveLeftToBed, .moveRightToToy, .moveRightToPillow]
                return animations.randomElement() ?? .moveRightToFood
            case .middle:
                animations = [.moveLeftToBed, .moveRightToFood, .moveLeftToBed, .moveRightToToy]
                return animations.randomElement() ?? .moveLeftToBed
            case .toy:
                animations = [.moveLeftToBed, .moveRightToPillow, .moveLeftToFood, .moveLeftToCenter]
                return animations.randomElement() ?? .moveLeftToBed
            case .potty:
                animations = [.moveRightToPillow, .moveLeftToFood, .moveLeftToWater, .moveLeftToToy]
                return animations.randomElement() ?? .moveRightToPillow
            case .ceiling:
                animations = [.moveLeftToBed, .moveRightToToy, .moveLeftToWater, .moveRightToFood]
                return animations.randomElement() ?? .moveLeftToBed
            case .game:
                animations = [.moveRightToPotty, .moveRightToCenter, .moveRightToFood, .moveRightToWater]
                return animations.randomElement() ?? .moveRightToPotty
            case .pillow:
                animations = [.moveLeftToGame, .moveLeftToToy, . moveLeftToCenter, .moveLeftToBed, .moveLeftToPotty]
                return animations.randomElement() ?? .moveLeftToGame
            }
        } else if AnimationManager.mood == .happy && AnimationManager.location != .ceiling {
            return .floatUp
        } else {
            return randomMovementAnimation()
        }
    }

    func randomPlaceAnimation() -> Animation {
        var animations: [Animation] = [.bounce]

        switch AnimationManager.location {
            case .bed:
                animations = [.sleep, .bounce]
                return animations.randomElement() ?? .bounce
            case .food:
                if StatusManager.summonedToWater {
                    removeFoodSummon()
                }

                if StatusManager.hasFood {
                    animations = [.eat, .bounce]
                } else if StatusManager.hasEaten == false && StatusManager.hasFood == false {
                    animations = [.linger]
                } else {
                    animations = [.bounce]
                }
                return animations.randomElement() ?? .bounce
            case .water:
                if StatusManager.summonedToWater {
                    removeWaterSummon()
                }

                if StatusManager.hasWater {
                    animations = [.drink, .bounce]
                } else if StatusManager.hasDrunk == false && StatusManager.hasWater == false {
                    animations = [.linger]
                } else {
                    animations = [.bounce]
                }

                return animations.randomElement() ?? .bounce
            case .middle:
                animations = [.bounce]
                return animations.randomElement() ?? .bounce
            case .toy:
                if StatusManager.summonedToToy {
                    animations = [.play]
                    removeToySummon()
                } else {
                    animations = [.play, .bounce]
                }

                return animations.randomElement() ?? .bounce
            case .potty:
                if summonedToPotty() && hasCleanPotty() {
                    animations = [.moveIntoPotty]
                    removePottySummon()
                } else if hasCleanPotty() == false {
                    animations = [.linger]
                } else if StatusManager.hasCleanPotty {
                    animations = [.moveIntoPotty]
                } else {
                    animations = [.linger]
                }

                return animations.randomElement() ?? .linger
            case .ceiling:
                animations = [.floatLeft, .floatRight, .floatSleep]
                return animations.randomElement() ?? .floatSleep
            case .game:
                if StatusManager.summonedToGame {
                    animations = [.playGame]
                    removeGameSummon()
                } else {
                    animations = [.playGame, .bounce]
                }

                return animations.randomElement() ?? .bounce
            case .pillow:
                animations = [.sleep, .bounce]
                return animations.randomElement() ?? .sleep
        }
    }

    func updateLocation(movement: Animation) {
        switch movement {
        case .moveLeftToBed:
            AnimationManager.location = .bed
        case .moveRightToPillow:
            AnimationManager.location = .pillow
        case .moveLeftToGame:
            AnimationManager.location = .game
        case .moveLeftToCenter, .moveRightToCenter:
            AnimationManager.location = .middle
        case .moveLeftToToy, .moveRightToToy:
            AnimationManager.location = .toy
        case .moveRightToPotty, .moveLeftToPotty:
            AnimationManager.location = .potty
        case .moveLeftToWater, .moveRightToWater:
            AnimationManager.location = .water
        case .moveLeftToFood, .moveRightToFood:
            AnimationManager.location = .food
        case .floatUp:
            AnimationManager.location = .ceiling
        default:
            return
        }
    }

    func randomizeAnimationType() -> Animation {
        let range = [1,2,3,4]
        let animation = range.randomElement()

        if animation == 1 {
            print("move")
            AnimationManager.movement = .moving
            return summoned()
        } else if animation == 2 {
            print("place animation")
            AnimationManager.movement = .staying

            return randomPlaceAnimation()
        } else if animation == 3 {
            AnimationManager.movement = .staying
            print("sleep from stopmoving")

            switch AnimationManager.location {
            case .ceiling:
                return .floatSleep
            default:
                return .sleep
            }
        } else {
            AnimationManager.movement = .staying
            print("pause")

            switch AnimationManager.location {
            case .ceiling:
                return .bounce
            default:
                return .pause
            }
        }
    }

    func summoned() -> Animation {
        // if summoned to location by user tap and conditions are met, execute action
        if summonedToToy() && getAnimationLocation() != .toy && hasPlayed() == false {
            removeToySummon()
            return .moveRightToToy
        } else if summonedToGame() && getAnimationLocation() != .game && hasPlayed() == false {
            removeGameSummon()
            return .moveLeftToGame
        } else if summonedToWater() && hasDrunk() == false {
            removeWaterSummon()

            switch AnimationManager.location {
            case .water:
                return .drink
            case .bed:
                return .moveRightToWater
            case .food:
                return .moveLeftToWater
            case .middle:
                return .moveLeftToWater
            case .toy:
                return .moveLeftToWater
            case .potty:
                return .moveLeftToWater
            case .ceiling:
                return .moveLeftToWater
            case .game:
                return .moveRightToWater
            case .pillow:
                return .moveLeftToWater
            }
        } else if summonedToFood() && hasEaten() == false {
            removeFoodSummon()

            switch AnimationManager.location {
            case .food:
                return .eat
            case .bed:
                return .moveRightToFood
            case .water:
                return .moveRightToFood
            case .middle:
                return .moveRightToFood
            case .toy:
                return .moveLeftToFood
            case .potty:
                return .moveLeftToFood
            case .ceiling:
                return .moveRightToFood
            case .game:
                return .moveRightToFood
            case .pillow:
                return .moveLeftToFood
            }
        } else if summonedToPotty() && hasCleanPotty() {
            removePottySummon()

            switch AnimationManager.location {
            case .pillow:
                return .moveLeftToPotty
            default:
                return .moveRightToPotty
            }
        } else if summonedToFire() {
            removeFireSummon()

            if AnimationManager.location != .pillow {
                return .moveRightToPillow
            } else {
                return .sleep
            }
        } else {
            // reset summons
            resetSummons()
            return randomMovementAnimation()
        }
    }
}
