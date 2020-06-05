//
//  Harvested.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/5/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Harvested {
    
    // items that have been harvested and are in basket
    static var loaded: [HarvestedItem] = []
    
    // harvested item quantities (in basket)
    static var basketCounts: [Plant: Int] = [
        Plant.chard: 0,
        Plant.geranium: 0,
        Plant.jade: 0,
        Plant.lemon: 0,
        Plant.pumpkin: 0,
        Plant.redTulip: 0,
    ]
    
    // list of all possible basket items
    static var basketItems: [BasketItem] = [
        BasketItem(name: "Red tulip cuttings", plant: .redTulip),
        BasketItem(name: "Jade cuttings", plant: .jade),
        BasketItem(name: "Chard stems", plant: .chard),
        BasketItem(name: "Lemons", plant: .lemon),
        BasketItem(name: "Pumpkins", plant: .pumpkin),
        BasketItem(name: "Geranium cuttings", plant: .geranium)
    ]
}

struct BasketItem {
    let name: String
    let plant: Plant
}
