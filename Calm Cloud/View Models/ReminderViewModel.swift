//
//  ReminderViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/30/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class ReminderViewModel {

    func getReminderCount() -> Int {
        return ReminderManager.remindersList.count
    }

    func getReminderName(index: Int) -> String {
        return ReminderManager.remindersList[index].name ?? ""
    }

    func getHourMinute(index: Int) -> String {
        var hour = ReminderManager.remindersList[index].hour
        var minute = ReminderManager.remindersList[index].minute

        if minute < 10 {
            return "\(hour):0\(minute)"
        } else {
            return "\(hour):\(minute)"
        }
    }

    func getDayOrRepeat(index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        var reminder = ReminderManager.remindersList[index]
        
        if reminder.date == nil {
            return "Daily"
        } else if let day = reminder.date {
            return dateFormatter.string(from: day)
        } else {
            return ""
        }
    }

    func getTime(date: Date) -> (hour: Int64?, minute: Int64?) {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        guard let hour = components.hour, let minute = components.minute else { return (nil, nil) }

        return (Int64(hour), Int64(minute))
    }

    func loadReminders() {
        // load saved reminders
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Reminder>(entityName: "Reminder")

        do {
            ReminderManager.remindersList = try managedContext.fetch(fetchRequest)
            print("reminders loaded")
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    func saveReminder(message: UITextField, datePicker: UIDatePicker, switchOn: Bool) {
        // save reminder
        if message.text != "" {
            var managedContext = CoreDataManager.shared.managedObjectContext
            let newReminder = Reminder(context: managedContext)

            newReminder.name = message.text
            newReminder.id = Date()
            
            var result = getTime(date: datePicker.date)
            if let hour = result.hour, let minute = result.minute {
                newReminder.hour = hour
                newReminder.minute = minute
            }

            if switchOn {
                newReminder.date = nil
            } else {
                newReminder.date = datePicker.date
            }

            ReminderManager.remindersList.append(newReminder)
            NotificationManager.addNotification(for: newReminder)

            do {
                try managedContext.save()
                print("saved reminder")
            } catch {
                // this should never be displayed but is here to cover the possibility
                //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
            }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        }
    }

    func fullDelete(index: Int) {
        // delete reminder, including notification
        var reminder = ReminderManager.remindersList[index]
        
        var managedContext = CoreDataManager.shared.managedObjectContext

        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = "\(reminder.id)"
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])

        ReminderManager.remindersList.remove(at: index)

        managedContext.delete(reminder)

        do {
            try managedContext.save()
            print("delete successful")
        } catch {
            print("Failed to delete")
        }
    }
}
