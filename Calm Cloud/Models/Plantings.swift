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
        Plant.chard: 1,
        Plant.geranium: 1,
        Plant.jade: 1,
        Plant.lemon: 1,
        Plant.pumpkin: 1,
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
    ]
    
    // list of all available seedlings
    static let seedlings = [
        Seedling(name: "Red Tulip", image: UIImage(named: "redtulip")!, plant: .redTulip, allowedArea: .flowerStrips, price: 10),
        Seedling(name: "Jade", image: UIImage(named: "jade")!, plant: .jade, allowedArea: .lowPot, price: 25),
        Seedling(name: "Carrot", image: UIImage(named: "carrot")!, plant: .carrot, allowedArea: .flowerStrips, price: 15),
        Seedling(name: "Rainbow Chard", image: UIImage(named: "chard")!, plant: .chard, allowedArea: .planter, price: 20),
        Seedling(name: "Lemon Tree", image: UIImage(named: "lemon")!, plant: .lemon, allowedArea: .tallPot, price: 50),
        Seedling(name: "Pink Tulip", image: UIImage(named: "pinktulip")!, plant: .pinkTulip, allowedArea: .flowerStrips, price: 15),
        Seedling(name: "Bell Pepper", image: UIImage(named: "pepper")!, plant: .pepper, allowedArea: .planter, price: 25),
        Seedling(name: "Pumpkin", image: UIImage(named: "pumpkin")!, plant: .pumpkin, allowedArea: .vegetablePlot, price: 30),
        Seedling(name: "Pink Geranium", image: UIImage(named: "geranium")!, plant: .geranium, allowedArea: .smallPot, price: 18),
        Seedling(name: "Strawberry", image: UIImage(named: "strawberry")!, plant: .strawberry, allowedArea: .vegetablePlot, price: 20),
        Seedling(name: "Kale", image: UIImage(named: "kale")!, plant: .kale, allowedArea: .planter, price: 15),
        Seedling(name: "Yellow Tulip", image: UIImage(named: "yellowtulip")!, plant: .yellowTulip, allowedArea: .flowerStrips, price: 15),
        Seedling(name: "Lime Tree", image: UIImage(named: "lime")!, plant: .lime, allowedArea: .tallPot, price: 50),
        Seedling(name: "Yellow Squash", image: UIImage(named: "squash")!, plant: .squash, allowedArea: .vegetablePlot, price: 25),
        Seedling(name: "Red Geranium", image: UIImage(named: "redgeranium")!, plant: .redGeranium, allowedArea: .smallPot, price: 18),
        Seedling(name: "Watermelon", image: UIImage(named: "watermelon")!, plant: .watermelon, allowedArea: .vegetablePlot, price: 30),
        Seedling(name: "Grape Tomato", image: UIImage(named: "tomato")!, plant: .tomato, allowedArea: .planter, price: 25),
        Seedling(name: "White Tulip", image: UIImage(named: "whitetulip")!, plant: .whiteTulip, allowedArea: .flowerStrips, price: 12)
    ]
}

struct Seedling {
    let name: String
    let image: UIImage
    let plant: Plant
    let allowedArea: Area
    let price: Int
}

