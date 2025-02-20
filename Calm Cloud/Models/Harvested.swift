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

    // items to display on basket view
    static var itemsToShow: [BasketItem] = []
    
    // harvested item quantities (in basket)
    static var basketCounts: [Plant: Int] = [
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
        Plant.cherryTomato: 0,
        Plant.kale: 0,
        Plant.orange: 0,
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
        Plant.daisy: 0,
        Plant.cauliflower: 0,
        Plant.eggplant: 0,
        Plant.daffodil: 0,
        Plant.beans: 0,
        Plant.corn: 0,
        Plant.sunflower: 0,
        Plant.tomato: 0,
    ]
    
    // list of all possible basket items
    static var basketItems: [BasketItem] = [
        BasketItem(name: "Beans", plant: .beans),
        BasketItem(name: "Bell peppers", plant: .pepper),
        BasketItem(name: "Black petunia cuttings", plant: .blackPetunia),
        BasketItem(name: "Blue petunia cuttings", plant: .bluePetunia),
        BasketItem(name: "Carrots", plant: .carrot),
        BasketItem(name: "Cauliflower", plant: .cauliflower),
        BasketItem(name: "Cherry tomatoes", plant: .cherryTomato),
        BasketItem(name: "Corn", plant: .corn),
        BasketItem(name: "Daffodil", plant: .daffodil),
        BasketItem(name: "Daisy cuttings", plant: .daisy),
        BasketItem(name: "Eggplant", plant: .eggplant),
        BasketItem(name: "Fushsia zinnia cuttings", plant: .zinnia),
        BasketItem(name: "Jade cuttings", plant: .jade),
        BasketItem(name: "Kale", plant: .kale),
        BasketItem(name: "Lavendar zinnia cuttings", plant: .lavendarZinnia),
        BasketItem(name: "Lemons", plant: .lemon),
        BasketItem(name: "Limes", plant: .lime),
        BasketItem(name: "Lobelia cuttings", plant: .lobelia),
        BasketItem(name: "Marigold", plant: .marigold),
        BasketItem(name: "Oranges", plant: .orange),
        BasketItem(name: "Paddle Plant", plant: .paddle),
        BasketItem(name: "Pink geranium flowers", plant: .geranium),
        BasketItem(name: "Pink tulip cuttings", plant: .pinkTulip),
        BasketItem(name: "Pumpkins", plant: .pumpkin),
        BasketItem(name: "Purple petunia cuttings", plant: .purplePetunia),
        BasketItem(name: "Rainbow chard stems", plant: .chard),
        BasketItem(name: "Red geranium flowers", plant: .redGeranium),
        BasketItem(name: "Red tulip cuttings", plant: .redTulip),
        BasketItem(name: "Salmon zinnia cuttings", plant: .salmonZinnia),
        BasketItem(name: "Strawberries", plant: .strawberry),
        BasketItem(name: "Striped petunia cuttings", plant: .stripedPetunia),
        BasketItem(name: "Summer Squash", plant: .squash),
        BasketItem(name: "Sunflower seeds", plant: .sunflower),
        BasketItem(name: "Tiger aloe", plant: .aloe),
        BasketItem(name: "Tomatoes", plant: .tomato),
        BasketItem(name: "Watermelons", plant: .watermelon),
        BasketItem(name: "White petunia cuttings", plant: .whitePetunia),
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
        Plant.cherryTomato: 0,
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
        Plant.daisy: 0,
        Plant.cauliflower: 0,
        Plant.eggplant: 0,
        Plant.beans: 0,
        Plant.corn: 0,
        Plant.sunflower: 0,
        Plant.tomato: 0,
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
        case .cherryTomato:
            return #imageLiteral(resourceName: "tomatosale")
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
        case .lobelia:
            return #imageLiteral(resourceName: "lobeliasale.png")
        case .purplePetunia:
            return #imageLiteral(resourceName: "purplepetuniasale.png")
        case .whitePetunia:
            return #imageLiteral(resourceName: "whitepetuniasale.png")
        case .stripedPetunia:
            return #imageLiteral(resourceName: "stripedpetuniasale.png")
        case .blackPetunia:
            return #imageLiteral(resourceName: "blackpetuniasale.png")
        case .bluePetunia:
            return #imageLiteral(resourceName: "bluepetuniasale.png")
        case .daisy:
            return #imageLiteral(resourceName: "daisysale.png")
        case .cauliflower:
            return #imageLiteral(resourceName: "cauliflowersale.png")
        case .eggplant:
            return #imageLiteral(resourceName: "eggplantsale.png")
        case .corn:
            return #imageLiteral(resourceName: "cornsale")
        case .beans:
            return #imageLiteral(resourceName: "beansale")
        case .sunflower:
            return #imageLiteral(resourceName: "sunflowersale")
        case .tomato:
            return #imageLiteral(resourceName: "tomatosale-1")
        }
    }
    
    // handle random purchases 'disappearance' from mysterious buyers we never see
    static func randomPurchases() -> Int? {
        // only check once per day, if not a new day exit
        let isSameDay = Recentness.isSameDay()
        
        if isSameDay == false {
            print("honor stand purchase is new day")
           
            var income = 0
            
            for (type, quantity) in Harvested.inStand {
                // cannot purchase what is not there
                if quantity == 0 {
                    print("honor stand item quantity zero")
                    continue
                }
                
                // random purchase bool
                var purchasesMade = Bool.random()
                
                if purchasesMade {
                    print("honor stand item purchased")
                    // random number bought
                    var number = Int.random(in: 1...quantity)
                    
                    var newQuantity: Int {
                        get {
                            if quantity - number > 0 {
                                return quantity - number
                            } else {
                                return 0
                            }
                        }
                    }
                    
                    // subtract items purchased and change quantity
                    // (new amount gets saved when this function is called)
                    Harvested.inStand[type] = newQuantity
                    
                    // random price paid
                    let prices = [5, 5, 5, 7, 7, 10, 12, 15]
                    
                    if let price = prices.randomElement() {
                        income += (price * number)
                    }
                } else {
                    // no purchase
                    print("no purchase from honor stand")
                    continue
                }
            }
            
            DataFunctions.saveHonorStandItems()
            
            return income
        } else {
            // if same day exit
            print("honor stand purchase not new day")
            return nil
        }
    }
}

struct BasketItem {
    let name: String
    let plant: Plant
}
