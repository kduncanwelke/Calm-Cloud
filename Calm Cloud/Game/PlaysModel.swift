//
//  PlaysModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 9/21/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

struct PlaysModel {

    static var loadedPlays: Plays?
    static var clouds = 0
    static var lastUsed: Date?
    static var mode: GameMode = .normal
}
