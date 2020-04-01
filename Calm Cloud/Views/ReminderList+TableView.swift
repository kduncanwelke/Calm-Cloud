//
//  ReminderList+TableView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Table view data source

extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderTableViewCell
    
        print("table")
        let reminder = remindersList[indexPath.row]
        
        cell.cellName.text = reminder.name
        cell.cellTime.text = "\(reminder.hour):\(reminder.minute)"
        cell.cellDateOrRepeat.text = {
            if reminder.reminderDate == nil {
                return "Daily"
            } else if let day = reminder.reminderDate {
                return "\(day)"
            } else {
                return ""
            }
        }()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            var reminderToDelete = remindersList[indexPath.row]
          
            // also delete notification and from core data
            
            remindersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
