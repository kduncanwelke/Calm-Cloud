//
//  QuantityChangeDelegate.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

protocol QuantityChangeDelegate: class {
    func didChangeQuantity(sender: BasketTableViewCell, number: Int)
}
