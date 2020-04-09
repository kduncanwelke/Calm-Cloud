//
//  ReminderList+TableView.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderManager.remindersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderTableViewCell
    
        let reminder = ReminderManager.remindersList[indexPath.row]
        
        cell.cellName.text = reminder.name
        
        let minute: String = {
            if reminder.minute < 10 {
                return "0\(reminder.minute)"
            } else {
                return "\(reminder.minute)"
            }
        }()
        
        cell.cellTime.text = "\(reminder.hour):\(minute)"
        
        cell.cellDateOrRepeat.text = {
            if reminder.date == nil {
                return "Daily"
            } else if let day = reminder.date {
                return dateFormatter.string(from: day)
            } else {
                return ""
            }
        }()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            var reminderToDelete = ReminderManager.remindersList[indexPath.row]
          
            fullDelete(reminder: reminderToDelete)
            
            ReminderManager.remindersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
