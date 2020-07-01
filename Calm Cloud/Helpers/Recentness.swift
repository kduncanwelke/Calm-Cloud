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
        
        let prevComponents = calendar.dateComponents([.hour, .minute], from: savedDate)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date())
            print(savedDate)
        print(Date())
        let difference = calendar.dateComponents([.minute], from: prevComponents, to: nowComponents).minute!
            print(difference)
            if difference >= 15 {
                // last completed item was more than 15 minutes ago
                timeLeft = 0
                TasksManager.lastOpened = Date()
                return true
            } else {
                // last completed item was within 15 minutes
                timeLeft = 15 - difference
                return false
            }
        }
        
        return true
    }
}
