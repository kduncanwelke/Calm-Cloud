//
//  Basket+TableView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/5/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketTableViewCell
        
        let item = itemsToShow[indexPath.row]
        
        if segmentedControl.selectedSegmentIndex == -1 {
            cell.stepper.isHidden = true
            cell.selectedNumber.isHidden = true
            cell.quantityLabel.isHidden = false
        } else {
            cell.stepper.isHidden = false
            cell.selectedNumber.isHidden = false
            cell.quantityLabel.isHidden = true
        }
        
        cell.itemLabel.text = item.name
        cell.selectedNumber.text = "0"
        cell.stepper.value = 0
        
        if let quantity = Harvested.basketCounts[item.plant] {
            cell.quantityLabel.text = "\(quantity)"
            cell.stepper.maximumValue = Double(quantity)
            cell.stepper.minimumValue = 0
        }
        
        return cell
    }
}

