//
//  JournalViewController+CollectionView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension FavoriteThingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        if finishedDeleting && editingPhotos == false {
            cell.checkButton.isHidden = true
        } else if finishedDeleting {
            cell.checkButton.isHidden = false
            cell.checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            cell.image.alpha = 1.0
        } else if editingPhotos {
            cell.checkButton.isHidden = false
        } else {
            cell.checkButton.isHidden = true
        }
        
        cell.image.image = PhotoManager.photos[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! PhotoCollectionViewCell
        
        if editingPhotos {
            finishedDeleting = false
            if let indexList = collectionView.indexPathsForSelectedItems {
                if indexList.contains(indexPath) {
                    tappedCell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                    tappedCell.image.alpha = 0.7
                    print("selected")
                }
            }
        } else {
            tappedImage = tappedCell.image.image
            PhotoManager.currentPhotoIndex = indexPath.row
            print(PhotoManager.currentPhotoIndex )
            performSegue(withIdentifier: "viewPhoto", sender: Any?.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! PhotoCollectionViewCell
        
        if editingPhotos {
            tappedCell.checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            tappedCell.image.alpha = 1.0
            print("not selected")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let maxNumColumns = 3
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
