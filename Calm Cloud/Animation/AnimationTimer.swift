//
//  AnimationTimer.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/22/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

class AnimationTimer {
    
    static var seconds = 0
    static var timer: Timer?
    
    // timer for animations
    static func beginTimer(repeatCount: Int) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds += 1
            
            if seconds >= repeatCount {
                stopTimer()
            }
        }
        
        timer?.fire()
    }
    
    static func stopTimer() {
        timer?.invalidate()
        seconds = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMovingOutside"), object: nil)
    }
    
    static func stop() {
        timer?.invalidate()
        seconds = 0
    }
}
