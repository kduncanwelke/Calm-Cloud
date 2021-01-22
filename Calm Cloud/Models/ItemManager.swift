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
        Item(name: "Pieces of Wood", image: UIImage(named: "wood")!, price: 12, hours: 3, type: .wood),
        Item(name: "Pile of Wood", image: UIImage(named: "wood2")!, price: 36, hours: 12, type: .wood),
        Item(name: "Stack of Wood", image: UIImage(named: "wood3")!, price: 48, hours: 24, type: .wood),
        Item(name: "Supply of Wood", image: UIImage(named: "wood4")!, price: 72, hours: 72, type: .wood),
        Item(name: "Sparkle!", image: UIImage(named: "sparkle")!, price: 12, hours: 3, type: .color),
        Item(name: "Sparkle! 2 Pack", image: UIImage(named: "sparkle2")!, price: 24, hours: 12, type: .color),
        Item(name: "Sparkle! 3 Pack", image: UIImage(named: "sparkle3")!, price: 36, hours: 24, type: .color)
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
