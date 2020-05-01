//
//  Activities+TableView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource, CellCheckDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilteringBySearch() {
            return searchResults.count
        } else {
            return ActivityManager.activities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        
        let activity: Activity
        
        if isFilteringBySearch() {
            activity = searchResults[indexPath.row]
        } else {
            activity = ActivityManager.activities[indexPath.row]
        }
        
        cell.cellLabel.text = activity.title
        cell.cellCategoryLabel.text = activity.category.rawValue
        
        if let completed = completion[activity.id] {
            if completed {
                cell.cellCheckButton.setImage(UIImage(named: "complete"), for: .normal)
            }
        } else {
            cell.cellCheckButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
            
        cell.cellDelegate = self
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        return cell
    }
    
    func didChangeSelectedState(sender: ActivityTableViewCell, isChecked: Bool) {
        let path = self.tableView.indexPath(for: sender)
        if let selected = path {
            
            if isChecked {
                completion[ActivityManager.activities[selected.row].id] = true
                saveCompletedActivity(id: ActivityManager.activities[selected.row].id)
            } else {
                completion[ActivityManager.activities[selected.row].id] = nil
                deleteIncompleteActivity(id: ActivityManager.activities[selected.row].id)
            }
            
            print("delegate called")
        }
    }
}

