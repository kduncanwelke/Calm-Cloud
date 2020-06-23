//
//  ViewController+Animations.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/22/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Animations
    
    func receivePackage() {
        // displayed upon level up when a seedling delivery arrives
        view.sendSubviewToBack(levelUpImage)
        door.isHidden = true
        openDoor.isHidden = false
        boxComingIn.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.boxComingIn.isHidden = true
            self.boxInside.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [unowned self] in
            self.door.isHidden = false
            self.openDoor.isHidden = true
        }
    }
    
    func floatUp() {
        print("float")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        cloudKitty.move(to: ceilingDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .ceiling
    }
    
    // left movemenet
    
    func floatLeft() {
        print("float left")
        cloudKitty.animationImages = AnimationManager.upsideDownLeft
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/6)
        cloudKitty.move(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToBed() {
        print("left to bed")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed
    }
    
    func moveLeftToFood() {
        print("left to food")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let foodBowlDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: foodBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .food
    }
    
    func moveLeftToWater() {
        print("left to water")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: waterBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .water
    }
    
    func moveLeftToCenter() {
        print("left to center")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        cloudKitty.move(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .middle
    }
    
    func moveLeftToToy() {
        print("right to toy")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let toyDestination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        cloudKitty.move(to: toyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .toy
    }
    
    // right movement
    
    func floatRight() {
        print("float right")
        cloudKitty.animationImages = AnimationManager.upsideDownRight
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/1.12, y: container.frame.height/6)
        cloudKitty.move(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToFood() {
        print("right to food")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let foodBowlDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: foodBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .food
    }
    
    func moveRightToWater() {
        print("right to water")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: waterBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .water
    }
    
    func moveRightToPotty() {
        print("right to potty")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let pottyDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2)
        cloudKitty.move(to: pottyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .potty
    }
    
    func moveIntoPotty() {
        print("potty")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let pottyDestination = CGPoint(x: container.frame.width/1.12, y: (container.frame.height/3)*1.55)
        cloudKitty.moveToPotty(to: pottyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .potty
    }
    
    func moveRightToToy() {
        print("right to toy")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let toyDestination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        cloudKitty.move(to: toyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .toy
    }
    
    func moveRightToCenter() {
        print("right to center")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        cloudKitty.move(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .middle
    }
    
    // bed animations
    
    func sleep() {
        print("sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func bounce() {
        print("bounce")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.startAnimating()
        
        let destination: CGPoint
        
        // determine location for bounce animation
        switch AnimationManager.location {
        case .bed:
            destination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        case .food:
            destination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
        case .water:
            destination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        case .middle:
            destination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        case .toy:
            destination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        case .potty:
            destination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2)
        case .ceiling:
            destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY)
        }
        
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMove(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // food bowl animation
    
    func eat() {
        print("eat")
        cloudKitty.animationImages = AnimationManager.eatAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
        hasEaten = true
        setMood()
    }
    
    // water bowl animations
    
    func drink() {
        print("drink")
        cloudKitty.animationImages = AnimationManager.drinkAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
        hasDrunk = true
        setMood()
    }
    
    // toy animations
    
    func play() {
        print("play")
        cloudKitty.animationImages = AnimationManager.playAnimation
        toyImage.animationImages = AnimationManager.toyAnimation
        cloudKitty.animationDuration = 1.0
        toyImage.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        toyImage.animationRepeatCount = 0
        cloudKitty.startAnimating()
        toyImage.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
        hasPlayed = true
        isPlaying = true
        setMood()
    }
    
    // litter box animations
    
    func dig() {
        print("dig")
        cloudKitty.animationImages = AnimationManager.digAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    // ceiling animations
    
    func floatSleep() {
        print("float sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        let destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY)
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMove(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // place non-specific animations
    
    func pause() {
        // static non-moving 'animation'
        cloudKitty.image = AnimationManager.startImage
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func linger() {
        // switch from side to side
        print("linger")
        cloudKitty.animationImages = AnimationManager.lingerAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    // randomization for location-specific animations
    
    func randomBedAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            sleep()
        } else {
            bounce()
        }
    }
    
    func randomFoodAnimation() {
        let range = [1,2,3]
        let animation = range.randomElement()
        
        if summonedToFood {
            summonedToFood = false
        }
        
        if hasEaten == false && hasFood {
            eat()
        } else if hasEaten == false && hasFood == false {
            linger()
        } else if animation == 1 && hasFood {
            eat()
        } else if animation == 2 {
            linger()
        } else {
            bounce()
        }
    }
    
    func randomWaterAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if summonedToWater {
            summonedToWater = false
        }
        
        if hasDrunk == false && hasWater {
            drink()
        } else if animation == 1 && hasWater {
            drink()
        } else {
            bounce()
        }
    }
    
    func randomToyAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if summonedToToy {
            play()
            summonedToToy = false
        } else if animation == 1 {
            play()
        } else {
            bounce()
        }
    }
    
    func randomPottyAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if summonedToPotty && hasCleanPotty {
            moveIntoPotty()
            summonedToPotty = false
        } else if hasCleanPotty == false {
            linger()
        } else if animation == 1 && hasCleanPotty {
            moveIntoPotty()
        } else {
            linger()
        }
    }
    
    func randomCenterAnimation() {
        bounce()
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
}
