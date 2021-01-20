//
//  Store+CollectionView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return Plantings.seedlings.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return ItemManager.items.count
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! StoreCollectionViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let plant: Seedling
            plant = Plantings.seedlings[indexPath.row]
        
            cell.nameLabel.text = plant.name
            cell.itemImage.image = plant.image
            
            let availableWidth = collectionView.frame.width
            if (availableWidth / 3) < 160.0 {
                // don't add cell alternating colors if only two cells across
                if Colors.colorfulCells.contains(indexPath.row) {
                    cell.backgroundColor = Colors.mint
                } else {
                    cell.backgroundColor = .white
                }
            } else {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = Colors.mint
                } else {
                    cell.backgroundColor = .white
                }
            }
            
            cell.priceLabel.text = "\(plant.price)"
            cell.coinImage.isHidden = false
            cell.area.text = plant.allowedArea.rawValue
            
            if let number = Plantings.availableSeedlings[plant.plant] {
                cell.numberOwned.text = "\(number) owned"
            } else {
                cell.numberOwned.text = "0 owned"
            }
            
            cell.growthSpeed.setTitle(plant.growthSpeed.rawValue, for: .normal)
            
            switch plant.growthSpeed {
            case .fast:
                cell.growthSpeed.setBackgroundImage(UIImage(named: "fast"), for: .normal)
            case .medium:
                cell.growthSpeed.setBackgroundImage(UIImage(named: "medium"), for: .normal)
            case .slow:
                cell.growthSpeed.setBackgroundImage(UIImage(named: "slow"), for: .normal)
            }
            
            cell.growthSpeed.isHidden = false
            
            cell.purchaseDescription.text = ""
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let object: Item
            object = ItemManager.items[indexPath.row]
            
            cell.nameLabel.text = object.name
            cell.itemImage.image = object.image
            
            let availableWidth = collectionView.frame.width
            if (availableWidth / 3) < 160.0 {
                // don't add cell alternating colors if only two cells across
                if Colors.colorfulCells.contains(indexPath.row) {
                    cell.backgroundColor = Colors.mint
                } else {
                    cell.backgroundColor = .white
                }
            } else {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = Colors.mint
                } else {
                    cell.backgroundColor = .white
                }
            }
            
            cell.priceLabel.text = "\(object.price)"
            cell.coinImage.isHidden = false
            cell.area.text = ""
            
            cell.numberOwned.text = ""
            cell.growthSpeed.isHidden = true
            
            switch object.type {
            case .wood:
                cell.purchaseDescription.text = "Add \(object.hours) hour(s) of fireplace time"
            case .color:
                cell.purchaseDescription.text = "Add \(object.hours) hour(s) of colorful fire"
            }
        } else {
            let item: SKProduct
            item = products[indexPath.row]
            print("title")
            print(item.localizedTitle)
            print("price")
            print(item.price)
            print("descrip")
            print(item.localizedDescription)
            cell.nameLabel.text = item.localizedTitle
            cell.itemImage.image = Products.productImages[item.productIdentifier]
            cell.priceLabel.text = "\(item.price)"
            
            let availableWidth = collectionView.frame.width
            if (availableWidth / 3) < 160.0 {
                if Colors.colorfulCells.contains(indexPath.row) {
                    cell.backgroundColor = Colors.mint
                } else {
                    cell.backgroundColor = .white
                }
            } else {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = Colors.mint
                } else {
                    cell.backgroundColor = .white
                }
            }
            
            cell.coinImage.isHidden = true
            cell.numberOwned.text = ""
            cell.area.text = ""
            cell.purchaseDescription.text = item.localizedDescription
            cell.growthSpeed.isHidden = true
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            // in seedling shop view
            let plant: Seedling
            plant = Plantings.seedlings[indexPath.row]
            PlantManager.buying = plant
            purchaseContainer.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUI"), object: nil)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let object: Item
            object = ItemManager.items[indexPath.row]
            ItemManager.buying = object
            purchaseContainer.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUI"), object: nil)
        } else {
            // in coin shop view, make purchase
            let isAuthorizedForPayments = SKPaymentQueue.canMakePayments()
            
            if isAuthorizedForPayments && !products.isEmpty {
                if NetworkMonitor.connection {
                    StoreObserver.iapObserver.buy(products[indexPath.row])
                    print("tapped cell")
                    print(products[indexPath.row].productIdentifier)
                    guard let coins = Products.productQuantities[products[indexPath.row].productIdentifier] else { return }
                    StoreObserver.coins = coins
                } else {
                    showAlert(title: "Purchases unavailable", message: "Purchases cannot be processed without a network connection - please try again")
                }
            } else {
                showAlert(title: "Payments not authorized", message: "This device is not permitted to process payments")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        var maxNumColumns = 3
        
        if (availableWidth / 3) < 160.0 {
            maxNumColumns = 2
        }
        
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        return CGSize(width: cellWidth, height: 192.00)
    }
}
