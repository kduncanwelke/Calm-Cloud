//
//  StatusManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/27/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct StatusManager {

    // state management for main view
    static var hasFood = false
    static var hasWater = false
    static var hasCleanPotty = false
    static var hasEaten = false
    static var hasDrunk = false
    static var hasBeenPet = false
    static var isPlaying = false
    static var hasPlayed = false
    static var summonedToFood = false
    static var summonedToWater = false
    static var summonedToToy = false
    static var summonedToPotty = false
    static var inPotty = false
    static var stopped = false
    static var lightsOff = false
    static var playingMusic = false
    static var stringLightsOn = false
    static var summonedToGame = false
    static var summonedToFire = false
    static var playingGame = false
    static var fireOn = false
    static var returnedFromSegue = false
}
