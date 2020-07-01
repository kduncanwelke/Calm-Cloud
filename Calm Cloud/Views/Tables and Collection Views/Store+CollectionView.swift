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
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = Colors.mint
            } else {
                cell.backgroundColor = .white
            }
            
            if let number = Plantings.availableSeedlings[plant.plant] {
                cell.numberOwned.text = "\(number) owned"
            } else {
                cell.numberOwned.text = "0 owned"
            }
        } else {
            let item: SKProduct
            item = products[indexPath.row]
            
            cell.nameLabel.text = item.localizedTitle
            cell.itemImage.image = nil // add image later
            cell.priceLabel.text = "\(item.price)"
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = Colors.mint
            } else {
                cell.backgroundColor = .white
            }
            
            cell.numberOwned.text = ""
            
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            // in seedling shop view
            let plant: Seedling
            plant = Plantings.seedlings[indexPath.row]
           
            purchaseContainer.isHidden = false
        } else {
            // in coin shop view, make purchase
            let isAuthorizedForPayments = SKPaymentQueue.canMakePayments()
            
            if isAuthorizedForPayments && !products.isEmpty {
                if NetworkMonitor.connection {
                    StoreObserver.iapObserver.buy(products[indexPath.row])
                    print("tapped cell")
                   // guard let points = Products.productQuantities[products[indexPath.row].productIdentifier] else { return }
                    
                    //pawPoints = points
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
        let maxNumColumns = 3
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        return CGSize(width: cellWidth, height: 170.00)
    }
}
