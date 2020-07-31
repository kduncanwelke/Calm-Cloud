//
//  ViewController+CoreData.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/27/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ViewController {
    
    func isRecentEnough(date: Date?, recentness: Int) -> Bool {
        if let chosenDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: chosenDate, to: Date())
            let diff = components.hour
            
            if let difference = diff {
                if difference < recentness {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func checkFrequency(with care: Care) {
        if isRecentEnough(date: care.lastFed, recentness: 6) {
            hasFood = true
        }
        
        if isRecentEnough(date: care.lastWatered, recentness: 12) {
            hasWater = true
        }
        
        if isRecentEnough(date: care.lastCleaned, recentness: 24) {
            hasCleanPotty = true
        }
    }
    
    func loadCare() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Care>(entityName: "Care")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            if let care = result.first {
                CareManager.loaded = care
                checkFrequency(with: care)
            }
            print("care loaded")
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func saveCare(food: Date?, water: Date?, potty: Date?) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        guard let currentCare = CareManager.loaded else {
            let careSave = Care(context: managedContext)
            
            careSave.lastFed = food
            careSave.lastWatered = water
            careSave.lastCleaned = potty
            
            CareManager.loaded = careSave
            
            do {
                try managedContext.save()
                print("saved care")
            } catch {
                // this should never be displayed but is here to cover the possibility
                showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
            }
            
            return
        }
        
        // otherwise rewrite data
        if food != nil {
            currentCare.lastFed = food
        }
        
        if water != nil {
            currentCare.lastWatered = water
        }
        
        if potty != nil {
            currentCare.lastCleaned = potty
        }
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
    
    func loadPhotos() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        
        do {
            PhotoManager.loadedPhotos = try managedContext.fetch(fetchRequest)
            print("photos loaded")
            PhotoManager.photos.removeAll()
            DocumentsManager.filePaths.removeAll()
            
            for photoItem in PhotoManager.loadedPhotos {
                guard let filePath = photoItem.path else { return }
                let path = DocumentsManager.documentsURL.appendingPathComponent(filePath).path
                if FileManager.default.fileExists(atPath: path) {
                    if let contents = UIImage(contentsOfFile: path) {
                        PhotoManager.photos.append(contents)
                        DocumentsManager.filePaths.append(filePath)
                    }
                } else {
                    print("not found")
                }
            }
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func loadEntries() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
        
        do {
            EntryManager.loadedEntries = try managedContext.fetch(fetchRequest)
            print("entries loaded")
            EntryManager.loadedEntries.reverse()
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func loadTasks() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<DailyTasks>(entityName: "DailyTasks")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            if let tasks = result.first {
                TasksManager.loaded = tasks
                TasksManager.journal = tasks.journal
                TasksManager.photo = tasks.fave
                TasksManager.activities = tasks.activities
                TasksManager.rewardCollected = tasks.rewardCollected
                TasksManager.lastOpened = tasks.lastOpened
            }
            
            if let lastOpened = TasksManager.lastOpened {
                if Calendar.current.isDateInToday(lastOpened) == false {
                    // last opened not today, so reset tasks
                    TasksManager.journal = false
                    TasksManager.photo = false
                    TasksManager.activities = false
                    TasksManager.rewardCollected = false
                    print("tasks all clear")
                    DataFunctions.saveTasks()
                }
            }
            
            print("tasks loaded")
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
}
