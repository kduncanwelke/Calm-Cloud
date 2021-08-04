//
//  PlantPurchaseViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/4/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class PlantPurchaseViewModel {

    var costPer = 0
    var number = 0

    func updateNumber(with stepperNumber: Int) {
        number = stepperNumber
    }

    func getNumber() -> String {
        return "\(number)"
    }

    func getTotal() -> String {
        return " \(costPer * number)"
    }

    func zeroSelected() -> Bool {
        if number == 0 {
            return true
        } else {
            return false
        }
    }

    func sufficientFunds() -> Bool {
        if costPer * number > MoneyManager.total {
            return false
        } else {
            return true
        }
    }

    func reset() {
        number = 0
        costPer = 0
        ItemManager.buying = nil
        PlantManager.buying = nil
    }

    func purchase() {
        if let plant = PlantManager.buying {
            // update inventory
            if let oldCount = Plantings.availableSeedlings[plant.plant] {
                Plantings.availableSeedlings[plant.plant] = oldCount + number
                DataFunctions.saveInventory()
            }
        } else if let item = ItemManager.buying {
            // update total time available
            let hours = item.hours * number

            switch item.type {
            case .wood:
                DataFunctions.addFuel(hours: hours, type: .wood)
            case .color:
                DataFunctions.addFuel(hours: hours, type: .color)
            }
        }

        // deduct funds
        MoneyManager.total -= costPer * number
        DataFunctions.saveMoney()
    }

    func updateHowManyLabel() -> String? {
        if let item = ItemManager.buying {
            var hours = item.hours * number

            switch item.type {
            case .wood:
                return "+ \(hours) hour(s) of fireplace time \n (\(Fireplace.hours) hours left)"
            case .color:
                return "+ \(hours) hour(s) of colorful fire \n (\(Fireplace.colorHours) hours left)"
            }
        } else {
            return nil
        }
    }

    func getPrice() {
        if let plant = PlantManager.buying {
            costPer = plant.price
        } else if let item = ItemManager.buying {
            costPer = item.price
        }
    }

    func getName() -> String {
        if let plant = PlantManager.buying {
            return plant.name
        } else if let item = ItemManager.buying {
            return item.name
        } else {
            return ""
        }
    }

    func getImage() -> UIImage? {
        if let plant = PlantManager.buying {
            return plant.image
        } else if let item = ItemManager.buying {
            return item.image
        } else {
            return nil
        }
    }

    func getHowMany() -> String {
        if let plant = PlantManager.buying {
            if let number = Plantings.availableSeedlings[plant.plant] {
               return "How many?\n\(number) owned"
            } else {
               return "How many?\n0 owned"
            }
        } else if let item = ItemManager.buying {
            switch item.type {
            case .wood:
                 return "+ \(item.hours) hour(s) of fireplace time \n (\(Fireplace.hours) hours left)"
            case .color:
                return "+ \(item.hours) hour(s) of colorful fire \n (\(Fireplace.colorHours) hours left)"
            }
        } else {
            return ""
        }
    }
}
