//
//  Random.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/29/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Random {
    // random 75% chance generator
    static func randomChance() -> Bool {
        var randomInt = Int.random(in: 1...100)

        if randomInt < 76 {
            return true
        } else {
            return false
        }
    }
}
