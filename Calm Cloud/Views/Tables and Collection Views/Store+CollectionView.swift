//
//  Store+CollectionView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Plantings.seedlings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! StoreCollectionViewCell
        
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
       
        return cell
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
