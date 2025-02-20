//
//  Recentness.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Recentness {
    static var timeLeft = 0
    
    static func lastCompleted() -> Bool {
        if let savedDate = TasksManager.lastOpened {
        // check when last viewed
        let calendar = Calendar.current

        let difference = calendar.dateComponents([.minute], from: savedDate, to: Date())
        print(difference.minute)

        guard let diff = difference.minute else { return false }
            print(difference)
            if diff >= 15 {
                // last completed item was more than 15 minutes ago
                timeLeft = 0
                TasksManager.lastOpened = Date()
                return true
            } else {
                // last completed item was within 15 minutes
                timeLeft = 15 - diff
                return false
            }
        }
        
        return true
    }
    
    static let userDefaultDate = "userDefaultDate"
    
    static func isSameDay() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let dateToCompare = calendar.component(.day , from: date)
        
        let userDefaultDate = UserDefaults.standard.integer(forKey: "userDefaultDate")
        
        if userDefaultDate != dateToCompare {
            UserDefaults.standard.set(dateToCompare, forKey: self.userDefaultDate)
            return false
        } else {
            return true
        }
    }
}
