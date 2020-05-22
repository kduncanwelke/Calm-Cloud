//
//  CoreData.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/22/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

struct DataFunctions {
    static func saveInventory() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        guard let currentInventory = Plantings.loaded else {
            let inventorySave = Inventory(context: managedContext)
            
            inventorySave.chards = Int16(Plantings.availableSeedlings[.chard]!)
            inventorySave.pinkGeraniums = Int16(Plantings.availableSeedlings[.geranium]!)
            inventorySave.jades = Int16(Plantings.availableSeedlings[.jade]!)
            inventorySave.lemons = Int16(Plantings.availableSeedlings[.lemon]!)
            inventorySave.pumpkins = Int16(Plantings.availableSeedlings[.pumpkin]!)
            inventorySave.redTulips = Int16(Plantings.availableSeedlings[.redTulip]!)
            
            Plantings.loaded = inventorySave
            
            do {
                try managedContext.save()
                print("saved inventory")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("failed to save inventory")
            }
            
            return
        }
        
        // otherwise rewrite data
        currentInventory.chards = Int16(Plantings.availableSeedlings[.chard]!)
        currentInventory.pinkGeraniums = Int16(Plantings.availableSeedlings[.geranium]!)
        currentInventory.jades = Int16(Plantings.availableSeedlings[.jade]!)
        currentInventory.lemons = Int16(Plantings.availableSeedlings[.lemon]!)
        currentInventory.pumpkins = Int16(Plantings.availableSeedlings[.pumpkin]!)
        currentInventory.redTulips = Int16(Plantings.availableSeedlings[.redTulip]!)
        
        Plantings.loaded = currentInventory
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("failed to save inventory")
        }
    }
    
    static func loadLevel() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Level>(entityName: "Level")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            if let level = result.first {
                LevelManager.loaded = level
                LevelManager.currentEXP = Int(level.currentEXP)
                LevelManager.currentLevel = Int(level.level)
                LevelManager.maxEXP = Int(level.expToNextLevel)
            }
            print("level loaded")
        } catch let error as NSError {
            print("level not loaded")
        }
    }
    
    static func saveLevel() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        guard let currentLevel = LevelManager.loaded else {
            let levelSave = Level(context: managedContext)
            
            levelSave.currentEXP = Int16(LevelManager.currentEXP)
            levelSave.expToNextLevel = Int16(LevelManager.maxEXP)
            levelSave.level = Int16(LevelManager.currentLevel)
            
            LevelManager.loaded = levelSave
            
            do {
                try managedContext.save()
                print("saved level")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("level not saved")
            }
            
            return
        }
        
        // otherwise rewrite data
        currentLevel.currentEXP = Int16(LevelManager.currentEXP)
        currentLevel.expToNextLevel = Int16(LevelManager.maxEXP)
        currentLevel.level = Int16(LevelManager.currentLevel)
        
        LevelManager.loaded = currentLevel
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("level not resaved")
        }
    }
}
