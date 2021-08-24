//
//  OutsideVM+CoreData.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/28/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

extension OutsideViewModel {

    func loadInventory() {
        // load seedling inventory
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<InventoryItem>(entityName: "InventoryItem")

        do {
            Plantings.loaded.removeAll()
            Plantings.loaded = try managedContext.fetch(fetchRequest)

            for item in Plantings.loaded {
                Plantings.availableSeedlings[Plant(rawValue: Int(item.id))!] = Int(item.quantity)
            }

            print("inventory loaded")
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    func loadPlots() {
        // load planted plots
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Plot>(entityName: "Plot")

        do {
            Plantings.plantings = try managedContext.fetch(fetchRequest)
            print("plots loaded")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadPlants"), object: nil)

        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    func savePlanting() {
        var id = Plantings.currentPlot
        var plant = PlantManager.selected.rawValue

        // save new planting
        var managedContext = CoreDataManager.shared.managedObjectContext

        let newPlot = Plot(context: managedContext)

        newPlot.id = Int16(id)
        newPlot.plant = Int16(plant)
        newPlot.date = Date()
        newPlot.mature = nil

        Plantings.plantings.append(newPlot)

        do {
            try managedContext.save()
            print("saved planting")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }

    func deletePlanting() {
        var id = Plantings.currentPlot
        
        var managedContext = CoreDataManager.shared.managedObjectContext

        let planting = Plantings.plantings.filter { $0.id == Int16(id) }.first

        guard let toDelete = planting else {
            print("didn't get item to delete")
            return }

        managedContext.delete(toDelete)

        do {
            try managedContext.save()
            print("delete successful")
        } catch {
            print("Failed to save")
        }

        loadPlots()
    }

    func saveWatering(id: Int) {
        // save watering status for planting
        var managedContext = CoreDataManager.shared.managedObjectContext

        let planting = Plantings.plantings.filter { $0.id == Int16(id) }.first

        guard let plot = planting else { return }

        if plot.lastWatered == nil {
            // plot has never been watered ie it's new
            plot.lastWatered = Date()
            plot.consecutiveWaterings = 1
            print("new watering")

            // update images
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadPlants"), object: nil)
        } else if PlantManager.needsWatering(date: plot.lastWatered) {
            // plant getting new watering date
            print("new watering date")

           if let lastWatered = plot.lastWatered {
                if Calendar.current.isDateInToday(lastWatered) == false {
                // if it's a new day, plants can be watered
                plot.consecutiveWaterings += 1
            } else {
                let differenceFromNowToLastWatering = PlantManager.checkDiff(date: lastWatered)

                // if plot was last watered 12 hours or more ago and that last watering was within the current day, add to waterings
                if differenceFromNowToLastWatering >= 12 && Calendar.current.isDateInToday(lastWatered) {
                    plot.consecutiveWaterings += 1
                } else if let prevWatered = plot.prevWatered {
                    let differenceFromNowToPrevWatering = PlantManager.checkDiff(date: prevWatered)

                    // if plot was last watered less than 12 hours ago and that last watering was within the current day, add to waterings
                    if differenceFromNowToPrevWatering <= 12 && Calendar.current.isDateInToday(prevWatered) {
                        plot.consecutiveWaterings += 1
                    }
                }
            }
        }

        plot.prevWatered = plot.lastWatered
        plot.lastWatered = Date()

        // update images
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadPlants"), object: nil)

        // use to set stage for current plant
        getStage(plot: plot)
        } else {
            print("no need for water")
            return
        }

        if PlantManager.currentStage == .seven && plot.mature == nil {
            plot.mature = Date()
            print("set mature date")
        }

        // exp gain from watering
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "waterPlant"), object: nil)

        do {
            try managedContext.save()
            print("saved watering")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
}
