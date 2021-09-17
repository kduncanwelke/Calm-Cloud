//
//  OutsideVM+Animation.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/30/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension OutsideViewModel {

    func randomMovementAnimation() -> OutsideAnimation {
        var move = Random.randomChance()

        var animations: [OutsideAnimation] = [.sleep]

        if move {
            switch AnimationManager.outsideLocation {
            case .back:
                animations = [.moveRightToGate, .moveLeftToCenter, .moveLeftToWidePot, .moveLeftToPlanter, .moveRightToPath]
                return animations.randomElement() ?? .moveRightToGate
            case .ceiling:
                animations = [.moveLeftToPlanter, .moveRightToBack, .moveRightToGate, .moveLeftToCenter]
                return animations.randomElement() ?? .moveLeftToPlanter
            case .front:
                animations = [.moveRightToBack, .moveLeftToPlanter, .moveLeftToWidePot, .moveRightToGate]
                return animations.randomElement() ?? .moveRightToBack
            case .gate:
                animations = [.moveLeftToPlanter, .moveLeftToCenter, .moveLeftToWidePot, .moveLeftToBack, .moveRightToPath]
                return animations.randomElement() ?? .moveLeftToPlanter
            case .path:
                animations = [.moveLeftToBack, .moveLeftToCenter, .moveRightToGate]
                return animations.randomElement() ?? .moveLeftToBack
            case .planter:
                animations = [.moveRightToBack, .moveRightToGate, .moveRightToCenter, .moveLeftToWidePot]
                return animations.randomElement() ?? .moveRightToBack
            case .pot:
                animations = [.moveRightToCenter, .moveRightToBack, .moveRightToCenter, .moveLeftToPlanter]
                return animations.randomElement() ?? .moveRightToCenter
            case .pots:
                animations = [.moveLeftToBack, .moveRightToCenter, .moveLeftToBack, .moveLeftToBack]
                return animations.randomElement() ?? .moveLeftToBack
            }
        } else {
            if AnimationManager.mood == .happy && AnimationManager.outsideLocation != .ceiling {
                return .floatUp
            } else {
                return randomMovementAnimation()
            }
        }
    }

    func randomPlaceAnimation() -> OutsideAnimation {
        var animations: [OutsideAnimation] = [.bounce]

        switch AnimationManager.outsideLocation {
            case .back:
                animations = [.bounce, .pause]
                return animations.randomElement() ?? .bounce
            case .ceiling:
                animations = [.floatLeft, .floatRight]
                return animations.randomElement() ?? .floatLeft
            case .front:
                animations = [.pause, .bounce]
                return animations.randomElement() ?? .pause
            case .gate:
                animations = [.bounce, .pause]
                return animations.randomElement() ?? .bounce
            case .path:
                animations = [.bounce, .pause]
                return animations.randomElement() ?? .bounce
            case .planter:
                animations = [.pause, .bounce]
                return animations.randomElement() ?? .pause
            case .pot:
                animations = [.bounce, .pause]
                return animations.randomElement() ?? .bounce
            case .pots:
                animations = [.pause, .bounce]
                return animations.randomElement() ?? .pause
        }
    }

    func updateLocation(movement: OutsideAnimation) {
        switch movement {
            case .moveRightToPots:
                AnimationManager.outsideLocation = .pots
            case .moveRightToCenter:
                AnimationManager.outsideLocation = .front
            case .moveRightToGate:
                AnimationManager.outsideLocation = .gate
            case .moveRightToBack, .moveLeftToBack:
                AnimationManager.outsideLocation = .back
            case .floatRight, .floatLeft, .floatUp:
                AnimationManager.outsideLocation = .ceiling
            case .moveLeftToCenter:
                AnimationManager.outsideLocation = .front
            case .moveLeftToWidePot:
                AnimationManager.outsideLocation = .pot
            case .moveLeftToPlanter:
                AnimationManager.outsideLocation = .planter
            case .moveRightToPath:
                AnimationManager.outsideLocation = .path
            default:
                return
        }
    }

    func randomizeAnimationType() -> OutsideAnimation {
        let range = [1,2,3,4]
        let animation = range.randomElement()

        if animation == 1 {
            print("move")
            AnimationManager.movement = .moving
            return randomMovementAnimation()
        } else if animation == 2 {
            print("place animation")
            AnimationManager.movement = .staying

            return randomPlaceAnimation()
        } else if animation == 3 {
            AnimationManager.movement = .staying
            print("sleep from stopmoving")

            switch AnimationManager.outsideLocation {
            case .ceiling:
                return .floatSleep
            default:
                return .sleep
            }
        } else {
            AnimationManager.movement = .staying
            print("pause")

            switch AnimationManager.outsideLocation {
            case .ceiling:
                return .bounce
            default:
                return .pause
            }
        }
    }
}
