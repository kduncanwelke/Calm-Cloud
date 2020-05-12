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
    
    var seeds = [Seedling(name: "Red Tulip", image: UIImage(named: "redtulip7")!, plant: .redTulip),Seedling(name: "Red Tulip", image: UIImage(named: "redtulip7")!, plant: .redTulip)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
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
        return seeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inventoryCell", for: indexPath) as! InventoryCollectionViewCell
        
        cell.cellLabel.text = seeds[indexPath.row].name
        cell.cellImage.image = seeds[indexPath.row].image
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! InventoryCollectionViewCell
        tappedCell.backgroundColor = UIColor(red: 0.66, green: 0.89, blue: 0.91, alpha: 1.00)
        // set plant selection
        PlantManager.selected = seeds[indexPath.row].plant
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! InventoryCollectionViewCell
        tappedCell.backgroundColor = UIColor.white
    }
}
