//
//  LevelManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/18/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct LevelManager {
    static var loaded: Level?
    
    static var currentLevel = 1
    static var maxEXP = 16
    static var currentEXP = 0
    
    static func calculateLevel() {
        let nextLevel = currentLevel + 1
        let num = Double(nextLevel) / 0.5
        let expToLevelUp = num * num
        
        let newEXP = currentEXP - maxEXP
        currentEXP = newEXP
        maxEXP = Int(expToLevelUp)
    }
    
    static let lightsUnlock = 12
    static let playerUnlock = 17
    static let lanternsUnlock = 25
}
