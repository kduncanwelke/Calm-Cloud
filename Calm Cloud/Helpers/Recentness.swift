//
//  Recentness.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct Recentness {
    static let userDefaultDate = "userDefaultDate"
    static var timeLeft = 0
    
    static func lastCompleted() -> Bool {
        // check when last viewed
        let date = Date()
        let calendar = Calendar.current
        let dateToCompare = calendar.component(.minute, from: date)
        
        let userDefaultDate = UserDefaults.standard.integer(forKey: "userDefaultDate")
        
        if dateToCompare > userDefaultDate {
            if dateToCompare - userDefaultDate >= 15 {
                // last completed item was more than 15 minutes ago
                UserDefaults.standard.set(dateToCompare, forKey: Recentness.userDefaultDate)
                timeLeft = 0
                return true
            } else {
                // last completed item was within 15 minutes
                timeLeft = 15 - (dateToCompare - userDefaultDate)
                return false
            }
        } else {
            // cases where default date is later in hour than compare date
            if userDefaultDate - dateToCompare >= 15 {
                // last completed item was more than 15 minutes ago
                UserDefaults.standard.set(dateToCompare, forKey: Recentness.userDefaultDate)
                timeLeft = 0
                return true
            } else {
                // last completed item was within 15 minutes
                timeLeft = 15 - (userDefaultDate - dateToCompare)
                return false
            }
        }
    }
}
