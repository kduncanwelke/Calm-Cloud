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
        Harvested.itemsToShow.removeAll()

        for basketObject in Harvested.basketItems {
            if Harvested.basketCounts[basketObject.plant] != 0 {
                Harvested.itemsToShow.append(basketObject)
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

        print("number donated \(numberDonated)")

        for _ in 1...numberDonated {
            let randomEXP = Int.random(in: 5...15)
            exp += randomEXP
            print("random exp")
        }

        LevelManager.currentEXP += exp

        // update exp amounts where displayed, in home view and outside view
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromBasket"), object: nil)

        DataFunctions.saveLevel()

        numberDonated = 0

        return exp
    }

    func adjustCounts(index: Int, segment: Int, direction: Direction, number: Int) {
        let item = Harvested.itemsToShow[index]

        if segment == 0 {
            switch direction {
            case .down:
                if let oldCount = Harvested.basketCounts[item.plant], let oldStandCount = Harvested.inStand[item.plant] {

                    print("decrease")
                    // put item back into basket
                    let newBasketCount = oldCount + 1
                    Harvested.basketCounts[item.plant] = newBasketCount

                    // decrease number in stand
                    let newStandCount = oldStandCount - 1

                    if newStandCount > 0 {
                        Harvested.inStand[item.plant] = newStandCount
                    } else {
                        Harvested.inStand[item.plant] = 0
                    }
               
                    numberSentToStand -= 1

                    print("basket count \(newBasketCount)")
                    print("stand count \(newStandCount)")
                    print("sent to stand \(numberSentToStand)")
                }
            case .up:
                if let oldCount = Harvested.basketCounts[item.plant], let oldStandCount = Harvested.inStand[item.plant] {

                    print("increase")
                    // take item out of basket
                    let newBasketCount = oldCount - 1

                    // increase number in stand
                    let newStandCount = oldStandCount + 1
                    Harvested.inStand[item.plant] = newStandCount

                    if newBasketCount > 0 {
                        Harvested.basketCounts[item.plant] = newBasketCount
                    } else {
                        Harvested.basketCounts[item.plant] = 0
                    }

                    numberSentToStand += 1

                    print("basket count \(newBasketCount)")
                    print("stand count \(newStandCount)")
                    print("sent to stand \(numberSentToStand)")
                }
            }
        } else if segment == 1 {
            switch direction {
                case .down:
                if let oldCount = Harvested.basketCounts[item.plant] {
                    // put back in basket
                    let newCount = oldCount + 1
                    Harvested.basketCounts[item.plant] = newCount
                    numberDonated -= 1

                    print("new basket count \(newCount)")
                    print("number donated \(numberDonated)")
                }
                case .up:
                if let oldCount = Harvested.basketCounts[item.plant] {
                    // remove from basket
                    let newCount = oldCount - 1

                    if newCount > 0 {
                        Harvested.basketCounts[item.plant] = newCount
                    } else {
                        Harvested.basketCounts[item.plant] = 0
                    }

                    numberDonated += 1

                    print("new basket count \(newCount)")
                    print("number donated \(numberDonated)")
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
                loadItems()

                return (false, true)
            } else {
                return (false, false)
            }
        } else {
            return (false, false)
        }
    }
}
