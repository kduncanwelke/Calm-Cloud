//
//  Activities+TableView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityManager.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        
        let activity = ActivityManager.activities[indexPath.row]
        
        cell.cellLabel.text = activity.title
        cell.cellCategoryLabel.text = activity.category.rawValue
    
        return cell
    }
}

