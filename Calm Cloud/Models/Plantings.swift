//
//  Seedling.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/8/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct Plantings {
    static var plantings: [Plot] = []
    
    static var loaded: Inventory?
    
    static var availableSeedlings: [Plant: Int] = [
        Plant.chard: 1,
        Plant.geranium: 1,
        Plant.jade: 1,
        Plant.lemon: 1,
        Plant.pumpkin: 1,
        Plant.redTulip: 2,
    ]
}
