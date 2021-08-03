//
//  ActivitiesViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/3/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

public class ActivitiesViewModel {

    func getActivityCount(filtering: Bool) -> Int {
        if filtering {
            return ActivityManager.searchResults.count
        } else {
            return ActivityManager.activities.count
        }
    }

    func getTitle(filtering: Bool, index: Int) -> String {
        if filtering {
            return ActivityManager.searchResults[index].title
        } else {
            return ActivityManager.activities[index].title
        }
    }

    func getCategory(filtering: Bool, index: Int) -> String {
        if filtering {
            return ActivityManager.searchResults[index].category.rawValue
        } else {
            return ActivityManager.activities[index].category.rawValue
        }
    }

    func checkCompleted(index: Int) -> Bool {
        if let completed = ActivityManager.completion[ActivityManager.activities[index].id] {
            return true
        } else {
            return false
        }
    }

    func getSearchResults(searchText: String) {
        ActivityManager.searchResults = ActivityManager.activities.filter({(activity: Activity) -> Bool in
            return (activity.title.lowercased().contains(searchText.lowercased())) || (activity.category.rawValue.lowercased().contains(searchText.lowercased()))
        })
    }

    func checkOffActivity(index: Int) {
        ActivityManager.completion[ActivityManager.activities[index].id] = true
        saveCompletedActivity(id: ActivityManager.activities[index].id)
    }

    func uncheckActivity(index: Int) {
        ActivityManager.completion[ActivityManager.activities[index].id] = nil
        deleteIncompleteActivity(id: ActivityManager.activities[index].id)
    }

    func loadCompleted() {
        // load completed items
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<ActivityId>(entityName: "ActivityId")

        do {
            ActivityManager.loaded = try managedContext.fetch(fetchRequest)

            if let lastOpened = TasksManager.lastOpened {
                // if it's same day load activities
                if Calendar.current.isDateInToday(lastOpened) {
                    print("same day")
                    // same day, no changes
                    for item in  ActivityManager.loaded {
                        ActivityManager.completion[Int(item.id)] = true
                    }

                    if  ActivityManager.loaded.count >= 3 {
                        if TasksManager.activities == false {
                            TasksManager.activities = true
                            DataFunctions.saveTasks(updatingActivity: false, removeAll: false)
                        }
                    }
                }
            } else {
                // new day, do nothing as activities are wiped
                print("new day")
            }
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    func saveCompletedActivity(id: Int) {
        // save item that has been completed
        var managedContext = CoreDataManager.shared.managedObjectContext
        let activitySave = ActivityId(context: managedContext)

        activitySave.id = Int16(id)

        do {
            try managedContext.save()
            print("saved activity")
        } catch let error as NSError {
            print(error)
            // this should never be displayed but is here to cover the possibility
            //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }

        DataFunctions.saveTasks(updatingActivity: true, removeAll: false)
        loadCompleted()
    }

    func deleteIncompleteActivity(id: Int) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var toDelete: ActivityId

        for item in  ActivityManager.loaded {
            if item.id == Int16(id) {
                toDelete = item
                managedContext.delete(toDelete)
            }
        }

        do {
            try managedContext.save()
            print("delete successful")
        } catch {
            print("Failed to save")
        }
    }
}
