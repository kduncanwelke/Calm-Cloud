//
//  TasksViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/4/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class TasksViewModel {

    func activitiesCheck() -> UIImage? {
        if TasksManager.activities {
            return UIImage(named: "correct")
        } else {
            return UIImage(named: "unchecked")
        }
    }

    func journalCheck() -> UIImage? {
        if TasksManager.journal {
            return UIImage(named: "correct")
        } else {
            return UIImage(named: "unchecked")
        }
    }

    func photoCheck() -> UIImage? {
        if TasksManager.photo {
            return UIImage(named: "correct")
        } else {
            return UIImage(named: "unchecked")
        }
    }

    func toggleButtons() -> (hideComplete: Bool, hideReward: Bool) {
        if TasksManager.activities && TasksManager.journal && TasksManager.photo && TasksManager.rewardCollected == false {
            print("get reward")
            return (false, false)
        } else if TasksManager.activities && TasksManager.journal && TasksManager.photo && TasksManager.rewardCollected == true {
            print("reward already gotten")
            return (false, true)
        } else {
           return (true, true)
        }
    }

    func collectReward() {
        MoneyManager.total += 10
        TasksManager.rewardCollected = true
        DataFunctions.saveTasks(updatingActivity: false, removeAll: false)
    }
}
