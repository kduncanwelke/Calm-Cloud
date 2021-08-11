//
//  Toy.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/5/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import SpriteKit

class Toy: CustomStringConvertible, Hashable {

    init(column: Int, row: Int, toyType: ToyType) {
        self.column = column
        self.row = row
        self.toyType = toyType
    }

    var column: Int
    var row: Int
    let toyType: ToyType
    var sprite: SKSpriteNode?

    var hashValue: Int {
        return row * 10 + column
    }

    static func ==(lhs: Toy, rhs: Toy) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }

    var description: String {
        return "type:\(toyType) square:(\(column),\(row))"
    }
}

enum ToyType: Int {
    case unknown
    case lemon
    case lime
    case lobelia
    case orange
    case pumpkin
    case tomato

    var spriteName: String {
        let spriteNames = ["Lemon", "Lime", "Lobelia", "Orange", "Pumpkin", "Tomato"]

        return spriteNames[rawValue-1]
    }

    static func random() -> ToyType {
        return ToyType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}
