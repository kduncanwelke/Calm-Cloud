//
//  Harvested.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/5/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

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
    
    static var stand: [HonorStandItem] = []
    
    // items placed in honor stand
    static var inStand: [Plant: Int] = [
        Plant.chard: 0,
        Plant.geranium: 0,
        Plant.jade: 0,
        Plant.lemon: 0,
        Plant.pumpkin: 0,
        Plant.redTulip: 0,
    ]
    
    static func getStandImage(plant: Plant) -> UIImage {
        switch plant {
        case .chard:
            return #imageLiteral(resourceName: "chardsale.png")
        case .geranium:
            return #imageLiteral(resourceName: "geraniumsale.png")
        case .jade:
            return #imageLiteral(resourceName: "jadesale.png")
        case .lemon:
            return #imageLiteral(resourceName: "lemonssale.png")
        case .none:
            return #imageLiteral(resourceName: "emptyplot.png")
        case .pumpkin:
            return #imageLiteral(resourceName: "pumpkinsale.png")
        case .redTulip:
            return #imageLiteral(resourceName: "redtulipsale.png")
        }
    }
    
    // handle random purchases 'disappearance' from mysterious buyers we never see
    static func randomPurchases() -> Int? {
        // only check once per day, if not a new day exit
        if Recentness.checkIfNewDay() == false {
            return nil
        }
        
        var income = 0
        
        for (type, quantity) in Harvested.inStand {
            // cannot purchase what is not there
            if quantity == 0 {
                continue
            }
            
            // random purchase bool
            var purchasesMade = Bool.random()
            
            if purchasesMade {
                // random number bought
                var number = Int.random(in: 1...quantity)
                let newQuantity = quantity - number
                
                // subtract items purchased and change quantity
                // (new amount gets saved when this function is called)
                Harvested.inStand[type] = newQuantity
                
                // random price paid
                let prices = [10,15,20,25]
                
                if let price = prices.randomElement() {
                    income += (price * number)
                }
            } else {
                // no purchase
                continue
            }
        }
        
        return income
    }
}

struct BasketItem {
    let name: String
    let plant: Plant
}
