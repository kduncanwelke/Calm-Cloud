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
        
        for (type, quantity) in Plantings.availableSeedlings {
            for item in Plantings.loaded {
                if Int(item.id) == type.rawValue {
                    item.quantity = Int16(quantity)
                    resave.append(item)
                }
            }
        }
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("failed to save inventory")
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
        
        for (type, quantity) in Harvested.basketCounts {
            for item in Harvested.loaded {
                if Int(item.id) == type.rawValue {
                    item.quantity = Int16(quantity)
                    resave.append(item)
                    print(item)
                }
            }
        }
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("failed to save harvest")
        }
        
        Harvested.loaded.removeAll()
        Harvested.loaded = resave
        loadHonorStand()
    }
    
    static func loadHarvest() {
        // load harvest inventory
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<HarvestedItem>(entityName: "HarvestedItem")
        
        do {
            Harvested.loaded = try managedContext.fetch(fetchRequest)
            
            for item in Harvested.loaded {
                print("harvested")
                print(item.id)
                print(item.quantity)
                Harvested.basketCounts[Plant(rawValue: Int(item.id))!] = Int(item.quantity)
            }
            
            // if no harvest loaded, set all counts to zero
            if Harvested.loaded.isEmpty {
                for (plant, quantity) in Harvested.basketCounts {
                    Harvested.basketCounts[plant] = 0
                }
            }
            print("harvest loaded")
        } catch let error as NSError {
           // showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
            print("did not load harvest")
        }
    }
    
    // MARK: Honor stand
    
    static func loadHonorStand() {
        // load honor stand inventory
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<HonorStandItem>(entityName: "HonorStandItem")
        
        do {
            Harvested.stand = try managedContext.fetch(fetchRequest)
            
            for item in Harvested.stand {
                Harvested.inStand[Plant(rawValue: Int(item.id))!] = Int(item.quantity)
            }
            print("honor stand loaded")
        } catch let error as NSError {
            // showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
            print("did not load harvest")
        }
    }
    
    static func saveHonorStandItems() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        if Harvested.stand.isEmpty {
            for (type, quantity) in Harvested.inStand {
                
                let standSave = HonorStandItem(context: managedContext)
                
                standSave.id = Int16(type.rawValue)
                standSave.quantity = Int16(quantity)
                
                Harvested.stand.append(standSave)
                
                // update quantity in basket
                if let oldCount = Harvested.basketCounts[type] {
                    let newCount = oldCount - quantity
                    
                    Harvested.basketCounts[type] = newCount
                }
                
                do {
                    try managedContext.save()
                    print("saved honor stand item")
                } catch {
                    // this should never be displayed but is here to cover the possibility
                    print("failed to save honor stand")
                }
            }
            
            DataFunctions.saveHarvest()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadHonorStand"), object: nil)

            return
        }
        
        // otherwise rewrite data
        var resave: [HonorStandItem] = []
        
        for item in Harvested.stand {
            let quantity = Harvested.inStand[Plant(rawValue: Int(item.id))!]
            item.quantity = Int16(quantity!)
            
            resave.append(item)
        }
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("failed to save honor stand")
        }
        
        Harvested.stand.removeAll()
        Harvested.stand = resave

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadHonorStand"), object: nil)
        DataFunctions.saveHarvest()
    }
    
    // MARK: Money
    
    static func loadMoney() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Money>(entityName: "Money")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            if let money = result.first {
                MoneyManager.loaded = money
                MoneyManager.earnings = Int(money.earnings)
                MoneyManager.total = Int(money.total)
            }
            print("money loaded")
        } catch let error as NSError {
            print("money not loaded")
        }
    }
    
    static func saveMoney() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        guard let moneyLoaded = MoneyManager.loaded else {
            let moneySave = Money(context: managedContext)
            
            moneySave.earnings = Int16(MoneyManager.earnings)
            moneySave.total = Int16(MoneyManager.total)
            
            MoneyManager.loaded = moneySave
            
            do {
                try managedContext.save()
                print("saved money")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("money not saved")
            }
            
            return
        }
        
        // otherwise rewrite data
        moneyLoaded.earnings = Int16(MoneyManager.earnings)
        moneyLoaded.total = Int16(MoneyManager.total)
        
        MoneyManager.loaded = moneyLoaded
        
        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("money not resaved")
        }
    }
    
    // MARK: Tasks
    
    static func saveTasks(updatingActivity: Bool, removeAll: Bool) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        guard let prevSave = TasksManager.loaded else {
            let taskSave = DailyTasks(context: managedContext)
            
            taskSave.activities = TasksManager.activities
            taskSave.fave = TasksManager.photo
            taskSave.journal = TasksManager.journal
            taskSave.rewardCollected = TasksManager.rewardCollected
            
            // save last opened as initial open date
            taskSave.lastOpened = Date()
            
            TasksManager.loaded = taskSave
            
            do {
                try managedContext.save()
                print("saved tasks")
                TasksManager.lastOpened = taskSave.lastOpened
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("tasks not saved")
            }
            
            return
        }
        
        // otherwise rewrite data
        prevSave.activities = TasksManager.activities
        prevSave.fave = TasksManager.photo
        prevSave.journal = TasksManager.journal
        prevSave.rewardCollected = TasksManager.rewardCollected
        
        // wipe all tasks, as it is new day
        if removeAll {
            deleteActivities()
            // set last opened date for the day when clearing activities
            prevSave.lastOpened = Date()
        } else if updatingActivity {
            prevSave.lastOpened = Date()
        }
        
        // update tasks manager info
        TasksManager.loaded = prevSave
        
        do {
            try managedContext.save()
            print("resave successful")
            TasksManager.lastOpened = prevSave.lastOpened
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("tasks not resaved")
        }
    }
    
    static func deleteActivities() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<ActivityId>(entityName: "ActivityId")
        
        do {
            var loaded = try managedContext.fetch(fetchRequest)
            
            for item in loaded {
                managedContext.delete(item)
            }
            
            do {
                try managedContext.save()
                print("deleted all new day")
            } catch {
                print("Failed to save")
            }
            
        } catch let error as NSError {
            print("activities couldn't be deleted")
        }
    }
    
    // fireplace
    
    static func checkIfExpired(dateToCheck: Date?) -> Int? {
        if let day = dateToCheck {
            if day < Date() {
                // date is past, no hours left, fireplace cannot be activated
                //DataFunctions.noFuel()
                return nil
            } else {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour], from: day, to: Date())
                
                if let hoursLeft = components.hour {
                    return hoursLeft
                    print("day \(day)")
                    print("hours left \(hoursLeft)")
                } else {
                    // no hours left, fireplace cannot be activated
                    //DataFunctions.noFuel()
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
    static func loadFuel() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Fuel>(entityName: "Fuel")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            if let fuel = result.first {
                Fireplace.loaded = fuel
                Fireplace.lastsUntil = fuel.lastsUntil
                Fireplace.color = fuel.colors
                
                if let result = checkIfExpired(dateToCheck: Fireplace.lastsUntil) {
                    Fireplace.hours = result
                } else {
                    DataFunctions.noFuel(type: .wood)
                }
                
                if let answer = checkIfExpired(dateToCheck: Fireplace.color) {
                    Fireplace.colorHours = answer
                } else {
                    DataFunctions.noFuel(type: .color)
                }
            }
            print("fireplace loaded")
        } catch let error as NSError {
            print("fireplace not loaded")
        }
    }
    
    static func getHoursLeft(hours: Int, savedDate: Date?) -> Int? {
        if let oldDate = savedDate {
            let calendar = Calendar.current
            
            // calculate hours left
            let components = calendar.dateComponents([.hour], from: oldDate, to: Date())
            if let hoursLeft = components.hour {
                // add hours purchased to hours remaining
                let hourTotal = hoursLeft + hours
                
                return hourTotal
            } else {
                return nil
            }
        } else {
            // no time left
            return nil
        }
    }
    
    static func addFuel(hours: Int, type: ItemType) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        guard let fuelLoaded = Fireplace.loaded else {
            let fuelSave = Fuel(context: managedContext)
            
            let now = Date()
            let calendar = Calendar.current
            let newDate = calendar.date(byAdding: .hour, value: hours, to: now)
            
            Fireplace.loaded = fuelSave
            
            switch type {
            case .wood:
                // add wood
                Fireplace.hours = hours
                Fireplace.lastsUntil = newDate
                
                fuelSave.lastsUntil = Fireplace.lastsUntil
            case .color:
                // add color
                Fireplace.colorHours = hours
                Fireplace.color = newDate
                
                fuelSave.colors = Fireplace.color
            }
            
            do {
                try managedContext.save()
                print("saved fuel")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("fuel not saved")
            }
            
            return
        }
        
        // otherwise rewrite data
        let calendar = Calendar.current
        
        switch type {
        case .wood:
            if let hoursRemaining = getHoursLeft(hours: hours, savedDate: Fireplace.lastsUntil) {
                Fireplace.hours = hoursRemaining
                
                let newDate = calendar.date(byAdding: .hour, value: hoursRemaining, to: Date())
                
                Fireplace.lastsUntil = newDate
                
                fuelLoaded.lastsUntil = Fireplace.lastsUntil
            } else {
                // there is no fuel currently, add anew
                let now = Date()
                let newDate = calendar.date(byAdding: .hour, value: hours, to: now)
                
                Fireplace.lastsUntil = newDate
                Fireplace.hours = hours
                
                fuelLoaded.lastsUntil = Fireplace.lastsUntil
            }
        case .color:
            if let hoursRemaining = getHoursLeft(hours: hours, savedDate: Fireplace.color) {
                Fireplace.colorHours = hoursRemaining
                
                let newDate = calendar.date(byAdding: .hour, value: hoursRemaining, to: Date())
                
                Fireplace.color = newDate
                
                fuelLoaded.colors = Fireplace.color
            } else {
                // there is no fuel currently, add anew
                let now = Date()
                let newDate = calendar.date(byAdding: .hour, value: hours, to: now)
                
                Fireplace.color = newDate
                Fireplace.colorHours = hours
                
                fuelLoaded.colors = Fireplace.color
            }
        }
        
        Fireplace.loaded = fuelLoaded
        
        do {
            try managedContext.save()
            print("resave fuel successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("fuel not resaved")
        }
    }
    
    static func noFuel(type: ItemType) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch), should not happen with resave
        guard let fuelLoaded = Fireplace.loaded else {
            let fuelSave = Fuel(context: managedContext)
            
            switch type {
            case .wood:
                Fireplace.hours = 0
                Fireplace.lastsUntil = nil
                
                fuelSave.lastsUntil = Fireplace.lastsUntil
            case .color:
                Fireplace.colorHours = 0
                Fireplace.color = nil
                
                fuelSave.colors = Fireplace.color
            }
           
            Fireplace.loaded = fuelSave
            
            do {
                try managedContext.save()
                print("resaved no fuel")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("fuel not resaved")
            }
            
            return
        }
        
        // otherwise rewrite data
        switch type {
        case .wood:
            Fireplace.lastsUntil = nil
            Fireplace.hours = 0
            
            fuelLoaded.lastsUntil = Fireplace.lastsUntil
        case .color:
            Fireplace.color = nil
            Fireplace.colorHours = 0
            
            fuelLoaded.colors = Fireplace.color
        }
        
        Fireplace.loaded = fuelLoaded
        
        do {
            try managedContext.save()
            print("resave no fuel successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("no fuel not resaved")
        }
    }

    static func saveClouds() {
        var managedContext = CoreDataManager.shared.managedObjectContext

        // save anew if it doesn't exist (like on app initial launch)
        guard let playsLoaded = PlaysModel.loadedPlays else {
            let playsSave = Plays(context: managedContext)

            playsSave.clouds = Int16(PlaysModel.clouds)

            PlaysModel.loadedPlays = playsSave

            do {
                try managedContext.save()
                print("saved plays")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("plays not saved")
            }

            return
        }

        // otherwise rewrite data
        playsLoaded.clouds = Int16(PlaysModel.clouds)
    
        PlaysModel.loadedPlays = playsLoaded

        do {
            try managedContext.save()
            print("resave successful")
        } catch {
            // this should never be displayed but is here to cover the possibility
            print("plays not resaved")
        }
    }
}
