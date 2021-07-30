//
//  BasketViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/30/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation

public class BasketViewModel {

    var numberDonated = 0
    var numberSentToStand = 0

    func performDataLoads() {
        DataFunctions.loadHarvest()
    }

    func loadItems() {
        for (plant, number) in Harvested.basketCounts {
            if number != 0 {
                for item in Harvested.basketItems {
                    if item.plant == plant {
                        Harvested.itemsToShow.append(item)
                        break
                    }
                }
            }
        }
    }

    func enableDoneButtonStand() -> Bool {
        if numberSentToStand != 0 {
            return true
        } else {
            return false
        }
    }

    func enableDoneButtonDonation() -> Bool {
        if numberDonated != 0 {
            return true
        } else {
            return false
        }
    }

    func getItemTotal() -> Int {
        return Harvested.itemsToShow.count
    }

    func getName(index: Int) -> String {
        return Harvested.itemsToShow[index].name
    }

    func getQuantity(index: Int) -> Int {
        var item = Harvested.itemsToShow[index]

        if let count = Harvested.basketCounts[item.plant] {
            return count
        } else {
            return 0
        }
    }

    func randomEXP() -> Int {
        var exp = 0

        for _ in 1...numberDonated {
            let randomEXP = Int.random(in: 5...15)
            exp += randomEXP
        }

        LevelManager.currentEXP += exp

        // update exp amounts where displayed, in home view and outside view
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromBasket"), object: nil)

        DataFunctions.saveLevel()

        return exp
    }

    func adjustCounts(index: Int, segment: Int, direction: Direction, number: Int) {
        let item = Harvested.itemsToShow[index]

        if segment == 0 {
            Harvested.inStand[item.plant] = number

            switch direction {
            case .down:
                numberSentToStand -= 1
            case .up:
                numberSentToStand += 1
            }
        } else if segment == 1 {
            switch direction {
                case .down:
                if let oldCount = Harvested.basketCounts[item.plant] {
                    let newCount = oldCount + 1
                    Harvested.basketCounts[item.plant] = newCount
                    numberDonated -= 1
                }
                case .up:
                if let oldCount = Harvested.basketCounts[item.plant] {
                    let newCount = oldCount - 1

                    if newCount > 0 {
                        Harvested.basketCounts[item.plant] = newCount
                    } else {
                        Harvested.basketCounts[item.plant] = 0
                    }

                    numberDonated += 1
                }
            }
        }
    }

    func saveChanges(segment: Int) -> (honorStand: Bool, donated: Bool) {
        if segment == 0 {
            if numberSentToStand != 0 {
                DataFunctions.saveHonorStandItems()
            
                return (true, false)
            } else {
                return (false, false)
            }
        } else if segment == 1 {
            if numberDonated != 0 {
                DataFunctions.saveHarvest()

                numberDonated = 0

                return (false, true)
            } else {
                return (false, false)
            }
        } else {
            return (false, false)
        }
    }
}
