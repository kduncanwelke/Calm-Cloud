//
//  InventoryViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/8/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var plantSeedlingButton: UIButton!
    
    let seedlings = [Seedling(name: "Red Tulip", image: UIImage(named: "redtulip")!, plant: .redTulip, allowedArea: .flowerStrips), Seedling(name: "Jade", image: UIImage(named: "jade")!, plant: .jade, allowedArea: .lowPot), Seedling(name: "Rainbow Chard", image: UIImage(named: "chard")!, plant: .chard, allowedArea: .planter), Seedling(name: "Lemon Tree", image: UIImage(named: "lemon")!, plant: .lemon, allowedArea: .tallPot), Seedling(name: "Pumpkin", image: UIImage(named: "pumpkin")!, plant: .pumpkin, allowedArea: .vegetablePlot), Seedling(name: "Pink Geranium", image: UIImage(named: "geranium")!, plant: .geranium, allowedArea: .smallPot)]
    var validSeedlings: [Seedling] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setSeedlings()
    }
    
    @objc func reload() {
        validSeedlings.removeAll()
        setSeedlings()
        collectionView.reloadData()
    }
    
    func setSeedlings() {
        print(PlantManager.area)
        if PlantManager.area == .none {
            plantSeedlingButton.isHidden = true
            for seedling in seedlings {
                validSeedlings.append(seedling)
            }
        } else {
            plantSeedlingButton.isHidden = false
            for seedling in seedlings {
                if seedling.allowedArea == PlantManager.area {
                    validSeedlings.append(seedling)
                }
            }
        }
    }
    
    func clearSelections() {
        if let selections = collectionView.indexPathsForSelectedItems {
            for index in selections {
                collectionView.deselectItem(at: index, animated: false)
            }
        }
        
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: IBActions
    
    @IBAction func confirmPlanting(_ sender: UIButton) {
        if let selections = collectionView.indexPathsForSelectedItems {
            if selections.isEmpty {
                return
            }
        }
        
        if Plantings.availableSeedlings[PlantManager.selected] == 0 {
            return
        }
        
        clearSelections()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "plant"), object: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {
        clearSelections()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeInventory"), object: nil)
    }
    
}

extension InventoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return validSeedlings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inventoryCell", for: indexPath) as! InventoryCollectionViewCell
        
        if let number = Plantings.availableSeedlings[validSeedlings[indexPath.row].plant] {
            cell.cellLabel.text = validSeedlings[indexPath.row].name + "\nx\(number)"
        }
        cell.cellImage.image = validSeedlings[indexPath.row].image
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! InventoryCollectionViewCell
        tappedCell.backgroundColor = Colors.cellSelection
        // set plant selection
        PlantManager.selected = validSeedlings[indexPath.row].plant
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! InventoryCollectionViewCell
        tappedCell.backgroundColor = UIColor.white
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
