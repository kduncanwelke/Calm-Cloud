//
//  StoreViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/3/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import StoreKit

public class StoreViewModel {

    var products = [SKProduct]()
    var buyingProduct: SKProduct?

    func areThereProducts() -> Bool {
        if products.isEmpty == false {
            return true
        } else {
            return false
        }
    }

    func assignProducts(loadedProducts: [SKProduct]) {
        products = loadedProducts
    }

    func resetItems() {
        PlantManager.buying = nil
        ItemManager.buying = nil
    }

    func getCoinTotal() -> String {
        return "\(MoneyManager.total)"
    }

    func getProductIdentifiers() -> [String] {
        return [Products.tenCoins, Products.twentyCoins, Products.thirtyCoins, Products.fortyCoins, Products.fiftyCoins, Products.seventyCoins, Products.oneHundredCoins, Products.twoHundredCoins, Products.twoHundredFiftyCoins, Products.fiveHundredCoins]
    }

    func getItemCount(segment: Int) -> Int {
        if segment == 0 {
            return Plantings.seedlings.count
        } else if segment == 1 {
            return ItemManager.items.count
        } else {
            return products.count
        }
    }

    func getName(segment: Int, index: Int) -> String {
        if segment == 0 {
            return Plantings.seedlings[index].name
        } else if segment == 1 {
            return ItemManager.items[index].name
        } else {
            return products[index].localizedTitle
        }
    }

    func getImage(segment: Int, index: Int) -> UIImage? {
        if segment == 0 {
            return Plantings.seedlings[index].image
        } else if segment == 1 {
            return ItemManager.items[index].image
        } else {
            var item = products[index]
            return Products.productImages[item.productIdentifier]
        }
    }

    func setCellColor(availableWidth: CGFloat, index: Int) -> UIColor {
        if (availableWidth / 3) < 160.0 {
            // don't add cell alternating colors if only two cells across
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

    func getPrice(segment: Int, index: Int) -> String {
        if segment == 0 {
            return "\(Plantings.seedlings[index].price)"
        } else if segment == 1 {
            return "\(ItemManager.items[index].price)"
        } else {
            return "\(products[index].price)"
        }
    }

    func hideCoinImage(segment: Int, index: Int) -> Bool {
        if segment == 0 {
            return false
        } else if segment == 1 {
            return false
        } else {
            return true
        }
    }

    func getAreaText(segment: Int, index: Int) -> String {
        if segment == 0 {
            return Plantings.seedlings[index].allowedArea.rawValue
        } else {
            return ""
        }
    }

    func getNumberOwned(segment: Int, index: Int) -> String {
        if segment == 0 {
            var plant = Plantings.seedlings[index]
            
            if let number = Plantings.availableSeedlings[plant.plant] {
                return "\(number) owned"
            } else {
                return "0 owned"
            }
        } else {
            return ""
        }
    }

    func showGrowthSpeed(segment: Int, index: Int) -> (title: String?, image: UIImage?) {
        if segment == 0 {
            var plant = Plantings.seedlings[index]

            switch plant.growthSpeed {
            case .fast:
                return (plant.growthSpeed.rawValue, UIImage(named: "fast"))
            case .medium:
                return (plant.growthSpeed.rawValue,UIImage(named: "medium"))
            case .slow:
                return (plant.growthSpeed.rawValue, UIImage(named: "slow"))
            }
        } else {
            return (nil, nil)
        }
    }

    func getDescription(segment: Int, index: Int) -> String {
        if segment == 0 {
            return ""
        } else if segment == 1 {
            var object = ItemManager.items[index]

            switch object.type {
            case .wood:
                return "Adds \(object.hours) hours of fireplace time"
            case .color:
                return "Adds \(object.hours) hours of colorful fire time"
            }
        } else {
            var item = products[index]
            return item.localizedDescription
        }
    }

    func setBuying(segment: Int, index: Int) {
        if segment == 0 {
            PlantManager.buying = Plantings.seedlings[index]
        } else if segment == 1 {
            ItemManager.buying = ItemManager.items[index]
        } else {
            buyingProduct = products[index]
        }
    }

    func buy() {
        if let product = buyingProduct {
            StoreObserver.iapObserver.buy(product)
            
            guard let coins = Products.productQuantities[product.productIdentifier] else { return }
            StoreObserver.coins = coins
        }
    }
}
