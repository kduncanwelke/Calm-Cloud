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
    
    // MARK: Animations
    
    func floatUp() {
        print("float")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    // left movement
    
    func floatLeft() {
        print("float left")
        cloudKitty.animationImages = AnimationManager.upsideDownLeft
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToBack() {
        print("left to back")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToPlanter() {
        print("left to planter")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let planterDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2)
        cloudKitty.outsideMove(to: planterDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToWidePot() {
        print("left to wide pot")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let potDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToCenter() {
        print("left to center")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    // right movement
    
    func floatRight() {
        print("float right")
        cloudKitty.animationImages = AnimationManager.upsideDownRight
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/1.12, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToBack() {
        print("right to back")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToGate() {
        print("right to gate")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let gateDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*1.5)
        cloudKitty.outsideMove(to: gateDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToCenter() {
        print("right to center")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToPots() {
        print("right to pots")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let potsDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potsDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
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
}
