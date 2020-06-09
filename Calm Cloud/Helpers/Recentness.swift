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
    
    static func isSameDay() -> Bool {
        // check when last viewed
        let date = Date()
        let calendar = Calendar.current
        let dateToCompare = calendar.component(.day , from: date)
        
        let userDefaultDate = UserDefaults.standard.integer(forKey: "userDefaultDate")
        
        if userDefaultDate != dateToCompare {
            UserDefaults.standard.set(dateToCompare, forKey: Recentness.userDefaultDate)
            return false
        } else {
            return true
        }
    }
    
}
