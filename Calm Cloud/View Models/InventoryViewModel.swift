//
//  InventoryViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/4/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class InventoryViewModel {

    var validSeedlings: [Seedling] = []

    func getSeedlingCount() -> Int {
        return validSeedlings.count
    }

    func getNumberOwned(index: Int) -> String {
        var plant = validSeedlings[index]

        if let number = Plantings.availableSeedlings[plant.plant] {
            return "\(number) owned"
        } else {
            return "0 owned"
        }
    }

    func getArea(index: Int) -> String {
        var plant = validSeedlings[index]
        return plant.allowedArea.rawValue
    }

    func getName(index: Int) -> String {
        var plant = validSeedlings[index]
        return plant.name
    }

    func getImage(index: Int) -> UIImage {
        var plant = validSeedlings[index]
        return plant.image
    }

    func getGrowthSpeed(index: Int) -> String {
        var plant = validSeedlings[index]
        return plant.growthSpeed.rawValue
    }

    func getGrowthSpeedIndicator(index: Int) -> UIImage? {
        var plant = validSeedlings[index]

        switch plant.growthSpeed {
        case .fast:
            return UIImage(named: "fast")
        case .medium:
            return UIImage(named: "medium")
        case .slow:
            return UIImage(named: "slow")
        }
    }

    func getBackgroundColor(availableWidth: CGFloat, index: Int) -> UIColor {
        if (availableWidth / 3) < 130.0 {
            if Colors.colorfulCells.contains(index) {
                return Colors.mint
            } else {
                return .white
            }
        } else {
            if index % 2 == 0 {
                return Colors.mint
            } else {
                return .white
            }
        }
    }

    func setSelected(index: Int) {
        PlantManager.selected = validSeedlings[index].plant
    }

    func reset() {
        validSeedlings.removeAll()
    }

    func isCountZero() -> Bool {
        if Plantings.availableSeedlings[PlantManager.selected] == 0 {
            return true
        } else {
            return false
        }
    }

    func updatePlantCount() {
        // plant selection exists and is not zero, update count
        if let selectedSeedling = Plantings.availableSeedlings[PlantManager.selected] {
            Plantings.availableSeedlings[PlantManager.selected] = selectedSeedling - 1
        }
    }

    func setSeedlings() -> Bool {
        // show seedlings relevant to the chosen area if applicable
        if PlantManager.area == .none {
            for seedling in Plantings.seedlings {
                if Plantings.availableSeedlings[seedling.plant] != 0 {
                    validSeedlings.append(seedling)
                    print(seedling.plant)
                }
            }

            return true
        } else {
            for seedling in Plantings.seedlings {
                if seedling.allowedArea == PlantManager.area && Plantings.availableSeedlings[seedling.plant] != 0 {
                    validSeedlings.append(seedling)
                } else if (PlantManager.area == .rows || PlantManager.area == .planter) && Plantings.availableSeedlings[seedling.plant] != 0 {
                    if seedling.allowedArea == .multi {
                        validSeedlings.append(seedling)
                    }
                }
            }

            return false
        }
    }
}
