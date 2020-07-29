//
//  CareManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/27/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct CareManager {
    static var loaded: Care?
}

struct TasksManager {
    static var loaded: DailyTasks?
    
    static var journal = false
    static var photo = false
    static var activities = false
    static var rewardCollected = false
    static var lastOpened: Date?
}

enum Mode {
    case planting
    case watering
    case removal
}
