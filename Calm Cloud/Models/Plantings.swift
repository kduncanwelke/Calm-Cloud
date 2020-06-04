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
    
    static var loaded: [InventoryItem] = []
    
    static var availableSeedlings: [Plant: Int] = [
        Plant.chard: 1,
        Plant.geranium: 1,
        Plant.jade: 1,
        Plant.lemon: 1,
        Plant.pumpkin: 1,
        Plant.redTulip: 2,
    ]
    
    static let seedlings = [Seedling(name: "Red Tulip", image: UIImage(named: "redtulip")!, plant: .redTulip, allowedArea: .flowerStrips), Seedling(name: "Jade", image: UIImage(named: "jade")!, plant: .jade, allowedArea: .lowPot), Seedling(name: "Rainbow Chard", image: UIImage(named: "chard")!, plant: .chard, allowedArea: .planter), Seedling(name: "Lemon Tree", image: UIImage(named: "lemon")!, plant: .lemon, allowedArea: .tallPot), Seedling(name: "Pumpkin", image: UIImage(named: "pumpkin")!, plant: .pumpkin, allowedArea: .vegetablePlot), Seedling(name: "Pink Geranium", image: UIImage(named: "geranium")!, plant: .geranium, allowedArea: .smallPot)]
}
