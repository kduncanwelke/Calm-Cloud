//
//  ItemManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 1/11/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct ItemManager {
    static let items: [Item] = [
        Item(name: "Wood", image: UIImage(named: "wood")!, price: 6, hours: 1)
    ]
    
    static var buying: Item?
}

struct Item {
    let name: String
    let image: UIImage
    let price: Int
    let hours: Int
}
