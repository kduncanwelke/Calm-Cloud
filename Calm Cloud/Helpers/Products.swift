//
//  Products.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct Products {
    public static let tenCoins = "a"
    public static let twentyCoins = "b"
    public static let thirtyCoins = "c"
    public static let fortyCoins = "d"
    public static let fiftyCoins = "e"
    public static let seventyCoins = "f"
    public static let oneHundredCoins = "g"
    public static let twoHundredCoins = "h"
    public static let twoHundredFiftyCoins = "i"
    public static let fiveHundredCoins = "j"
    
    public static let productQuantities = [
        "tenCoins" : 10,
        "twentyCoins": 20,
        "thirtyCoins": 30,
        "fortyCoins": 40,
        "fiftyCoins": 50,
        "seventyCoins": 70,
        "oneHundredCoins": 100,
        "twoHundredCoins": 200,
        "twoHundredFiftyCoins": 250,
        "fiveHundredCoins": 500,
    ]
    
    public static let productImages: [String: UIImage] = [
        "a" : #imageLiteral(resourceName: "tencoins.png"),
        "b" : #imageLiteral(resourceName: "twentycoins.png"),
        "c" : #imageLiteral(resourceName: "thirtycoins.png"),
        "d" : #imageLiteral(resourceName: "fourtycoins.png"),
        "e" : #imageLiteral(resourceName: "fiftycoins.png"),
        "f" : #imageLiteral(resourceName: "seventycoins.png"),
        "g" : #imageLiteral(resourceName: "onehundredcoins.png"),
        "h" : #imageLiteral(resourceName: "twohundredcoins.png"),
        "i" : #imageLiteral(resourceName: "twohundredfiftycoins.png"),
        "j" : #imageLiteral(resourceName: "fivehundredcoins.png"),
    ]
}
