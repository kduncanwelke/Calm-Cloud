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
    // plants in plots
    static var plantings: [Plot] = []
    
    // seedlings in inventory
    static var loaded: [InventoryItem] = []
    
    // seedling quantities
    static var availableSeedlings: [Plant: Int] = [
        Plant.chard: 0,
        Plant.geranium: 0,
        Plant.jade: 0,
        Plant.lemon: 0,
        Plant.pumpkin: 0,
        Plant.redTulip: 2,
        Plant.redGeranium: 0,
        Plant.yellowTulip: 0,
        Plant.pinkTulip: 0,
        Plant.whiteTulip: 0,
        Plant.lime: 0,
        Plant.carrot: 0,
        Plant.squash: 0,
        Plant.strawberry: 0,
        Plant.watermelon: 0,
        Plant.pepper: 0,
        Plant.tomato: 0,
        Plant.kale: 0,
        Plant.orange: 0,
        Plant.daffodil: 0,
        Plant.zinnia: 0,
        Plant.lavendarZinnia: 0,
        Plant.salmonZinnia: 0,
        Plant.aloe: 0,
        Plant.paddle: 0,
        Plant.marigold: 0,
        Plant.lobelia: 0,
        Plant.purplePetunia: 0,
        Plant.whitePetunia: 0,
        Plant.stripedPetunia: 0,
        Plant.blackPetunia: 0,
        Plant.bluePetunia: 0,
    ]
    
    // list of all available seedlings
    static let seedlings = [
        Seedling(name: "Bell Pepper", image: UIImage(named: "pepper")!, plant: .pepper, allowedArea: .multi, price: 45, growthSpeed: .medium),
        Seedling(name: "Black Petunia", image: UIImage(named: "blackpetunia")!, plant: .blackPetunia, allowedArea: .smallPot, price: 120, growthSpeed: .fast),
        Seedling(name: "Blue Petunia", image: UIImage(named: "bluepetunia")!, plant: .bluePetunia, allowedArea: .smallPot, price: 100, growthSpeed: .fast),
        Seedling(name: "Carrot", image: UIImage(named: "carrot")!, plant: .carrot, allowedArea: .rows, price: 30, growthSpeed: .medium),
        Seedling(name: "Cherry Tomato", image: UIImage(named: "tomato")!, plant: .tomato, allowedArea: .planter, price: 45, growthSpeed: .medium),
        Seedling(name: "Daffodil", image: UIImage(named: "daffodil")!, plant: .daffodil, allowedArea: .rows, price: 30, growthSpeed: .fast),
        Seedling(name: "Fuchsia Zinnia", image: UIImage(named: "zinnia")!, plant: .zinnia, allowedArea: .rows, price: 60, growthSpeed: .medium),
        Seedling(name: "Jade", image: UIImage(named: "jade")!, plant: .jade, allowedArea: .lowPot, price: 50, growthSpeed: .medium),
        Seedling(name: "Kale", image: UIImage(named: "kale")!, plant: .kale, allowedArea: .multi, price: 65, growthSpeed: .slow),
        Seedling(name: "Lavendar Zinnia", image: UIImage(named: "lavendarzinnia")!, plant: .lavendarZinnia, allowedArea: .rows, price: 70, growthSpeed: .medium),
        Seedling(name: "Lemon Tree", image: UIImage(named: "lemon")!, plant: .lemon, allowedArea: .tallPot, price: 100, growthSpeed: .slow),
        Seedling(name: "Lime Tree", image: UIImage(named: "lime")!, plant: .lime, allowedArea: .tallPot, price: 120, growthSpeed: .slow),
        Seedling(name: "Lobelia", image: UIImage(named: "lobelia")!, plant: .lobelia, allowedArea: .smallPot, price: 80, growthSpeed: .medium),
        Seedling(name: "Marigold", image: UIImage(named: "marigold")!, plant: .marigold, allowedArea: .rows, price: 40, growthSpeed: .medium),
        Seedling(name: "Orange Tree", image: UIImage(named: "orange")!, plant: .orange, allowedArea: .tallPot, price: 150, growthSpeed: .slow),
        Seedling(name: "Paddle Plant", image: UIImage(named: "paddle")!, plant: .paddle, allowedArea: .lowPot, price: 75, growthSpeed: .medium),
        Seedling(name: "Pink Geranium", image: UIImage(named: "geranium")!, plant: .geranium, allowedArea: .smallPot, price: 50, growthSpeed: .fast),
        Seedling(name: "Pink Tulip", image: UIImage(named: "pinktulip")!, plant: .pinkTulip, allowedArea: .rows, price: 35, growthSpeed: .fast),
        Seedling(name: "Pumpkin", image: UIImage(named: "pumpkin")!, plant: .pumpkin, allowedArea: .vegetablePlot, price: 90, growthSpeed: .slow),
        Seedling(name: "Purple Petunia", image: UIImage(named: "purplepetunia")!, plant: .purplePetunia, allowedArea: .smallPot, price: 110, growthSpeed: .fast),
        Seedling(name: "Rainbow Chard", image: UIImage(named: "chard")!, plant: .chard, allowedArea: .multi, price: 75, growthSpeed: .medium),
        Seedling(name: "Red Geranium", image: UIImage(named: "redgeranium")!, plant: .redGeranium, allowedArea: .smallPot, price: 60, growthSpeed: .fast),
        Seedling(name: "Red Tulip", image: UIImage(named: "redtulip")!, plant: .redTulip, allowedArea: .rows, price: 20, growthSpeed: .fast),
        Seedling(name: "Salmon Zinnia", image: UIImage(named: "salmonzinnia")!, plant: .salmonZinnia, allowedArea: .rows, price: 70, growthSpeed: .medium),
        Seedling(name: "Strawberry", image: UIImage(named: "strawberry")!, plant: .strawberry, allowedArea: .vegetablePlot, price: 100, growthSpeed: .medium),
        Seedling(name: "Striped Petunia", image: UIImage(named: "stripedpetunia")!, plant: .stripedPetunia, allowedArea: .smallPot, price: 120, growthSpeed: .fast),
        Seedling(name: "Summer Squash", image: UIImage(named: "squash")!, plant: .squash, allowedArea: .vegetablePlot, price: 80, growthSpeed: .slow),
        Seedling(name: "Tiger Aloe", image: UIImage(named: "aloe")!, plant: .aloe, allowedArea: .lowPot, price: 75, growthSpeed: .fast),
        Seedling(name: "Yellow Tulip", image: UIImage(named: "yellowtulip")!, plant: .yellowTulip, allowedArea: .rows, price: 35, growthSpeed: .fast),
        Seedling(name: "Watermelon", image: UIImage(named: "watermelon")!, plant: .watermelon, allowedArea: .vegetablePlot, price: 50, growthSpeed: .slow),
        Seedling(name: "White Petunia", image: UIImage(named: "whitepetunia")!, plant: .whitePetunia, allowedArea: .smallPot, price: 100, growthSpeed: .fast),
        Seedling(name: "White Tulip", image: UIImage(named: "whitetulip")!, plant: .whiteTulip, allowedArea: .rows, price: 35, growthSpeed: .fast)
    ]
}

struct Seedling {
    let name: String
    let image: UIImage
    let plant: Plant
    let allowedArea: Area
    let price: Int
    let growthSpeed: Speed
}

enum Speed: String {
    case slow = "SLOW"
    case medium = "MED"
    case fast = "FAST"
}
