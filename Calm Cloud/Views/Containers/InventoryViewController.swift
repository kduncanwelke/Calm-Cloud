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
    
    // MARK: Variables
    
    private let inventoryViewModel = InventoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        plantSeedlingButton.isHidden = inventoryViewModel.setSeedlings()
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.reloadData()
    }
    
    @objc func reload() {
        // reload when re-shown
        inventoryViewModel.reset()
        plantSeedlingButton.isHidden = inventoryViewModel.setSeedlings()
        collectionView.reloadData()
    }

    func clearSelections() {
        // clear selections so they don't stick when this view reappears
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
        // if no selection, exist
        if let selections = collectionView.indexPathsForSelectedItems {
            if selections.isEmpty {
                return
            }
        }
        
        // if plant count is zero, exit
        if inventoryViewModel.isCountZero() {
            return
        }
        
        inventoryViewModel.updatePlantCount()
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
        return inventoryViewModel.getSeedlingCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inventoryCell", for: indexPath) as! InventoryCollectionViewCell

        cell.numberLabel.text = inventoryViewModel.getNumberOwned(index: indexPath.row)
        
        let availableWidth = collectionView.frame.width
        cell.backgroundColor = inventoryViewModel.getBackgroundColor(availableWidth: availableWidth, index: indexPath.row)
        
        cell.areaLabel.text = inventoryViewModel.getArea(index: indexPath.row)
        cell.cellLabel.text = inventoryViewModel.getName(index: indexPath.row)
        cell.cellImage.image = inventoryViewModel.getImage(index: indexPath.row)
        cell.growthSpeed.setTitle(inventoryViewModel.getGrowthSpeed(index: indexPath.row), for: .normal)
        cell.growthSpeed.setBackgroundImage(inventoryViewModel.getGrowthSpeedIndicator(index: indexPath.row), for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! InventoryCollectionViewCell
        tappedCell.backgroundColor = Colors.cellSelection
        // set plant selection
        inventoryViewModel.setSelected(index: indexPath.row)
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
        var maxNumColumns = 3
        
        if (availableWidth / 3) < 130.0 {
            maxNumColumns = 2
        }
        
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        return CGSize(width: cellWidth, height: 170.0)
    }
}
