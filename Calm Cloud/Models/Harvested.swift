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
        Plant.jade: 2,
        Plant.lemon: 0,
        Plant.pinkTulip: 0,
        Plant.pumpkin: 0,
        Plant.redTulip: 0,
        Plant.redGeranium: 0,
        Plant.yellowTulip: 0,
        Plant.whiteTulip: 0,
        Plant.lime: 5,
        Plant.carrot: 0,
        Plant.squash: 0,
        Plant.strawberry: 10,
        Plant.watermelon: 0,
        Plant.pepper: 0,
        Plant.tomato: 0,
        Plant.kale: 0,
        Plant.orange: 0,
        Plant.zinnia: 0,
        Plant.lavendarZinnia: 0,
        Plant.salmonZinnia: 0,
        Plant.aloe: 0,
        Plant.paddle: 0,
        Plant.marigold: 0,
    ]
    
    // list of all possible basket items
    static var basketItems: [BasketItem] = [
        BasketItem(name: "Bell peppers", plant: .pepper),
        BasketItem(name: "Carrots", plant: .carrot),
        BasketItem(name: "Daffodil", plant: .daffodil),
        BasketItem(name: "Fushsia Zinnia Cuttings", plant: .zinnia),
        BasketItem(name: "Grape tomatoes", plant: .tomato),
        BasketItem(name: "Jade cuttings", plant: .jade),
        BasketItem(name: "Kale", plant: .kale),
        BasketItem(name: "Lavendar zinnia cuttings", plant: .lavendarZinnia),
        BasketItem(name: "Lemons", plant: .lemon),
        BasketItem(name: "Limes", plant: .lime),
        BasketItem(name: "Marigold", plant: .marigold),
        BasketItem(name: "Oranges", plant: .orange),
        BasketItem(name: "Paddle Plant", plant: .paddle),
        BasketItem(name: "Pink geranium flowers", plant: .geranium),
        BasketItem(name: "Pink tulip cuttings", plant: .pinkTulip),
        BasketItem(name: "Pumpkins", plant: .pumpkin),
        BasketItem(name: "Rainbow chard stems", plant: .chard),
        BasketItem(name: "Red geranium flowers", plant: .redGeranium),
        BasketItem(name: "Red tulip cuttings", plant: .redTulip),
        BasketItem(name: "Salmon zinnia cuttings", plant: .salmonZinnia),
        BasketItem(name: "Strawberries", plant: .strawberry),
        BasketItem(name: "Summer Squash", plant: .squash),
        BasketItem(name: "Tiger Aloe", plant: .aloe),
        BasketItem(name: "Watermelons", plant: .watermelon),
        BasketItem(name: "White tulip cuttings", plant: .whiteTulip),
        BasketItem(name: "Yellow tulip cuttings", plant: .yellowTulip),
    ]
    
    static var stand: [HonorStandItem] = []
    
    // items placed in honor stand
    static var inStand: [Plant: Int] = [
        Plant.chard: 0,
        Plant.geranium: 0,
        Plant.jade: 0,
        Plant.lemon: 0,
        Plant.pinkTulip: 0,
        Plant.pumpkin: 0,
        Plant.redTulip: 0,
        Plant.redGeranium: 0,
        Plant.yellowTulip: 0,
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
        case .redGeranium:
            return #imageLiteral(resourceName: "redgeraniumsale.png")
        case .yellowTulip:
            return #imageLiteral(resourceName: "yellowtulipsale.png")
        case .pinkTulip:
            return #imageLiteral(resourceName: "pinktulipsale.png")
        case .whiteTulip:
            return #imageLiteral(resourceName: "whitetulipsale.png")
        case .lime:
            return #imageLiteral(resourceName: "limessale.png")
        case .carrot:
            return #imageLiteral(resourceName: "carrotsale.png")
        case .squash:
            return #imageLiteral(resourceName: "squashsale.png")
        case .strawberry:
            return #imageLiteral(resourceName: "strawberrysale.png")
        case .watermelon:
            return #imageLiteral(resourceName: "watermelonsale.png")
        case .pepper:
            return #imageLiteral(resourceName: "peppersale.png")
        case .tomato:
            return #imageLiteral(resourceName: "tomatosale.png")
        case .kale:
            return #imageLiteral(resourceName: "kalesale.png")
        case .orange:
            return #imageLiteral(resourceName: "orangesale.png")
        case .daffodil:
            return #imageLiteral(resourceName: "daffodilsale.png")
        case .zinnia:
            return #imageLiteral(resourceName: "zinniasale.png")
        case .lavendarZinnia:
            return #imageLiteral(resourceName: "lavendarzinniasale.png")
        case .salmonZinnia:
            return #imageLiteral(resourceName: "salmonzinniasale.png")
        case .aloe:
            return #imageLiteral(resourceName: "aloesale.png")
        case .paddle:
            return #imageLiteral(resourceName: "paddlesale.png")
        case .marigold:
            return #imageLiteral(resourceName: "marigoldsale.png")
        }
    }
    
    // handle random purchases 'disappearance' from mysterious buyers we never see
    static func randomPurchases() -> Int? {
        // only check once per day, if not a new day exit
        if let lastOpened = TasksManager.lastOpened {
            if Calendar.current.isDateInToday(lastOpened) == false {
                // if same day exit
                return nil
            }
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
                let prices = [7,10,14,18]
                
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
