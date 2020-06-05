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
    
    // MARK: Inventory
    
    static func saveInventory() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        if Plantings.loaded.isEmpty {
            for (type, quantity) in Plantings.availableSeedlings {
                
                let inventorySave = InventoryItem(context: managedContext)
                
                inventorySave.id = Int16(type.rawValue)
                inventorySave.quantity = Int16(quantity)
                    
                Plantings.loaded.append(inventorySave)
                
                do {
                    try managedContext.save()
                    print("saved inventory item")
                } catch {
                    // this should never be displayed but is here to cover the possibility
                    print("failed to save inventory")
                }
            }
            
            return
        }
        
        // otherwise rewrite data
        var resave: [InventoryItem] = []
        
        for item in Plantings.loaded {
            let quantity = Plantings.availableSeedlings[Plant(rawValue: Int(item.id))!]
            item.quantity = Int16(quantity!)
            
            resave.append(item)
            
            do {
                try managedContext.save()
                print("resave successful")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("failed to save inventory")
            }
        }
        
        Plantings.loaded.removeAll()
        Plantings.loaded = resave
    }
    
    // MARK: Level
    
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
    
    // MARK: Harvest
    
    static func saveHarvest() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        if Harvested.loaded.isEmpty {
            for (type, quantity) in Harvested.basketCounts {
                
                let harvestSave = HarvestedItem(context: managedContext)
                
                harvestSave.id = Int16(type.rawValue)
                harvestSave.quantity = Int16(quantity)
                
                Harvested.loaded.append(harvestSave)
                
                do {
                    try managedContext.save()
                    print("saved harvest item")
                } catch {
                    // this should never be displayed but is here to cover the possibility
                    print("failed to save harvest")
                }
            }
            
            return
        }
        
        // otherwise rewrite data
        var resave: [HarvestedItem] = []
        
        for item in Harvested.loaded {
            let quantity = Harvested.basketCounts[Plant(rawValue: Int(item.id))!]
            item.quantity = Int16(quantity!)
            
            resave.append(item)
            
            do {
                try managedContext.save()
                print("resave successful")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("failed to save inventory")
            }
        }
        
        Harvested.loaded.removeAll()
        Harvested.loaded = resave
    }
    
    static func loadHarvest() {
        // load harvest inventory
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<HarvestedItem>(entityName: "HarvestedItem")
        
        do {
            Harvested.loaded = try managedContext.fetch(fetchRequest)
            
            for item in Harvested.loaded {
                Harvested.basketCounts[Plant(rawValue: Int(item.id))!] = Int(item.quantity)
            }
            print("harvest loaded")
        } catch let error as NSError {
           // showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
            print("did not load harvest")
        }
    }
}
