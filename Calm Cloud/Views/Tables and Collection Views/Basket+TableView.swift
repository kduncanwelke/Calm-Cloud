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
        
        cell.itemLabel.text = item.name
        if let quantity = Harvested.basketCounts[item.plant] {
            cell.quantityLabel.text = "\(quantity)"
        }
        
        return cell
    }
}

