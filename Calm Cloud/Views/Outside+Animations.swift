//
//  Outside+Animations.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/22/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension OutsideViewController {
    
    // MARK: Animation control functions
    
    func randomRepeatCount() -> Int {
        // random repeat for animations
        var randomRepeatCount = Int.random(in: 4...8)
        print("repeat \(randomRepeatCount) times")
        return randomRepeatCount
    }
    
    func randomMoveOutside() {
        // randomize movement animations
        let range = [1,2,3,4,5]
        let animation = range.randomElement()
        
        if animation == 1 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveRightToGate()
            case .ceiling:
                moveLeftToPlanter()
            case .front:
                moveRightToBack()
            case .gate:
                moveLeftToPlanter()
            case .planter:
                moveRightToBack()
            case .pot:
                moveRightToCenter()
            case .pots:
                moveLeftToBack()
            }
        } else if animation == 2 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveLeftToCenter()
            case .ceiling:
                moveRightToBack()
            case .front:
                moveLeftToPlanter()
            case .gate:
                moveLeftToCenter()
            case .planter:
                moveRightToGate()
            case .pot:
                moveRightToBack()
            case .pots:
                moveRightToCenter()
            }
        } else if animation == 3 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveLeftToWidePot()
            case .ceiling:
                moveRightToGate()
            case .front:
                moveLeftToWidePot()
            case .gate:
                moveLeftToWidePot()
            case .planter:
                moveRightToCenter()
            case .pot:
                moveRightToCenter()
            case .pots:
                moveLeftToBack()
            }
        } else if animation == 4 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveLeftToPlanter()
            case .ceiling:
                moveLeftToCenter()
            case .front:
                moveRightToGate()
            case .gate:
                moveLeftToBack()
            case .planter:
                moveLeftToWidePot()
            case .pot:
                moveLeftToPlanter()
            case .pots:
                moveLeftToBack()
            }
        } else {
            if AnimationManager.mood == .happy && AnimationManager.location != .ceiling {
                floatUp()
            } else {
                randomMoveOutside()
            }
        }
    }
    
    @objc func stopMovingOutside() {
        if self.isViewLoaded && (self.view.window != nil) {
            print("outdoor view on screen")
            // run after an animation is complete, randomize next
            let range = [1,2,3,4,5]
            let animation = range.randomElement()
            cloudKitty.stopAnimating()
            
            if isStopped() {
                return
            }
            
            if animation == 1 {
                AnimationManager.movement = .moving
                randomMoveOutside()
            } else if animation == 2 {
                AnimationManager.movement = .staying
                switch AnimationManager.outsideLocation {
                case .back:
                    randomBackAnimation()
                case .ceiling:
                    randomCeilingAnimation()
                case .front:
                    randomFrontAnimation()
                case .gate:
                    randomGateAnimation()
                case .planter:
                    randomPlanterAnimation()
                case .pot:
                    randomPotAnimation()
                case .pots:
                    randomPotsAnimation()
                }
            } else if animation == 3 {
                switch AnimationManager.outsideLocation {
                case .ceiling:
                    floatSleep()
                default:
                    sleep()
                }
            } else if animation == 4 {
                AnimationManager.movement = .staying
                print("pause")
                switch AnimationManager.outsideLocation {
                case .ceiling:
                    bounce()
                default:
                    pause()
                }
            } else {
                if AnimationManager.mood == .happy && AnimationManager.outsideLocation != .ceiling {
                    floatUp()
                } else {
                    randomMoveOutside()
                }
            }
        }
    }
    
    
    // MARK: Animations
    
    func floatUp() {
        print("float")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .ceiling
    }
    
    // left movement
    
    func floatLeft() {
        print("float left")
        cloudKitty.animationImages = AnimationManager.upsideDownLeft
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .ceiling
    }
    
    func moveLeftToBack() {
        print("left to back")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .back
    }
    
    func moveLeftToPlanter() {
        print("left to planter")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let planterDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2)
        cloudKitty.outsideMove(to: planterDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .planter
    }
    
    func moveLeftToWidePot() {
        print("left to wide pot")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let potDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .pot
    }
    
    func moveLeftToCenter() {
        print("left to center")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .front
    }
    
    // right movement
    
    func floatRight() {
        print("float right")
        cloudKitty.animationImages = AnimationManager.upsideDownRight
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/1.12, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .ceiling
    }
    
    func moveRightToBack() {
        print("right to back")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .back
    }
    
    func moveRightToGate() {
        print("right to gate")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let gateDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*1.5)
        cloudKitty.outsideMove(to: gateDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .gate
    }
    
    func moveRightToCenter() {
        print("right to center")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .front
    }
    
    func moveRightToPots() {
        print("right to pots")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let potsDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potsDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .pots
    }
    
    // sleep animations
    
    func sleep() {
        print("sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func floatSleep() {
        print("float sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        let destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY)
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMoveOutside(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // place non-specific animations
    
    func bounce() {
        print("bounce")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.startAnimating()
        
        let destination: CGPoint
        
        switch AnimationManager.outsideLocation {
        case .ceiling:
            destination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        case .back:
            destination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        case .front:
            destination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        case .gate:
            destination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*1.5)
        case .planter:
            destination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2)
        case .pot:
            destination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2.4)
        case .pots:
            destination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2.4)
        }
        
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMoveOutside(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    func pause() {
        cloudKitty.image = AnimationManager.startImage
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func randomBackAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomCeilingAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            floatLeft()
        } else {
            floatRight()
        }
    }
    
    func randomFrontAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomGateAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomPlanterAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomPotAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomPotsAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
}
