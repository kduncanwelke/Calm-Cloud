//
//  Swap.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/20/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Swap: CustomStringConvertible, Hashable {
    let toyA: Toy
    let toyB: Toy

    init(toyA: Toy, toyB: Toy) {
        self.toyA = toyA
        self.toyB = toyB
    }

    var description: String {
        return "swap \(toyA) with \(toyB)"
    }

    var hashValue: Int {
        return toyA.hashValue ^ toyB.hashValue
    }

    static func ==(lhs: Swap, rhs: Swap) -> Bool {
        // equal if toys are same 
        return (lhs.toyA == rhs.toyA && lhs.toyB == rhs.toyB) || (lhs.toyB == rhs.toyA && lhs.toyA == rhs.toyB)
    }
}
