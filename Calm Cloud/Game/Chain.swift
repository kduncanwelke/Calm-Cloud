//
//  Chain.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/27/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

class Chain: Hashable, CustomStringConvertible {

    init(chainType: ChainType) {
        self.chainType = chainType
    }

    var toys: [Toy] = []
    var chainType: ChainType

    var score = 0

    enum ChainType: CustomStringConvertible {
        case horizontal
        case vertical

        var description: String {
            switch self {
            case .horizontal:
                return "Horizontal"
            case .vertical:
                return "Vertical"
            }
        }
    }

    var length: Int {
        return toys.count
    }

    var description: String {
        return "type: \(chainType) toys: \(toys)"
    }

    var hashValue: Int {
        return toys.reduce (0) { $0.hashValue ^ $1.hashValue }
    }

    static func ==(lhs: Chain, rhs: Chain) -> Bool {
        return lhs.toys == rhs.toys
    }

    func add(toy: Toy) {
        toys.append(toy)
    }

    func firstToy() -> Toy {
        return toys[0]
    }

    func lastToy() -> Toy {
        return toys[toys.count - 1]
    }
}
