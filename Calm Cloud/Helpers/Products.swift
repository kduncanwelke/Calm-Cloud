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
    public static let fillClouds = "1aa"
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
        "a": 10,
        "b": 20,
        "c": 30,
        "d": 40,
        "e": 50,
        "f": 70,
        "g": 100,
        "h": 200,
        "i": 250,
        "j": 500,
        "1aa": 0,
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
        "1aa": #imageLiteral(resourceName: "restoreplays"),
    ]
}
