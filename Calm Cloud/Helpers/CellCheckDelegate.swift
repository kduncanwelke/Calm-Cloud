//
//  CellCheckDelegate.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

protocol CellCheckDelegate: class {
    func didChangeSelectedState(sender: ActivityTableViewCell, isChecked: Bool)
}
