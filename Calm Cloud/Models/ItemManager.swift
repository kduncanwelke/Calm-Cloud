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
        Item(name: "Pieces of Wood", image: UIImage(named: "wood")!, price: 1, hours: 1, type: .wood),
        Item(name: "Pile of Wood", image: UIImage(named: "wood2")!, price: 36, hours: 6, type: .wood),
        Item(name: "Stack of Wood", image: UIImage(named: "wood3")!, price: 72, hours: 12, type: .wood),
        Item(name: "Supply of Wood", image: UIImage(named: "wood4")!, price: 144, hours: 24, type: .wood),
        Item(name: "Sparkle!", image: UIImage(named: "sparkle")!, price: 1, hours: 6, type: .color),
        Item(name: "Sparkle! 2 Pack", image: UIImage(named: "sparkle2")!, price: 20, hours: 12, type: .color),
        Item(name: "Sparkle! 3 Pack", image: UIImage(named: "sparkle3")!, price: 60, hours: 24, type: .color)
    ]
    
    static var buying: Item?
}

struct Item {
    let name: String
    let image: UIImage
    let price: Int
    let hours: Int
    let type: ItemType
}

enum ItemType {
    case wood
    case color
}
