//
//  NotificationManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/8/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static func addNotification(for reminder: Reminder) {
        let identifier = "\(reminder.id)"
        
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        
        guard let title = reminder.name else { return }
        notificationContent.title = "Calm Cloud Reminder"
        notificationContent.body = "\(title)"
        notificationContent.sound = UNNotificationSound.default
        
        // convert to calendar date
        let calendar = Calendar.current
        var components = DateComponents()
        var repeats = false
        
        if let notifDate = reminder.date {
            components = calendar.dateComponents([.year, .month, .day], from: notifDate)
            components.hour = Int(reminder.hour)
            components.minute = Int(reminder.minute)
            repeats = false
        } else {
            components.hour = Int(reminder.hour)
            components.minute = Int(reminder.minute)
            repeats = true
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        }
        
        print("notification added")
    }
}
