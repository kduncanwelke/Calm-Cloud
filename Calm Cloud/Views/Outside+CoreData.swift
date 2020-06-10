//
//  Outside+CoreData.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/11/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension OutsideViewController {
    
    func loadInventory() {
        // load seedling inventory
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<InventoryItem>(entityName: "InventoryItem")
        
        do {
            Plantings.loaded = try managedContext.fetch(fetchRequest)
            
            for item in Plantings.loaded {
                Plantings.availableSeedlings[Plant(rawValue: Int(item.id))!] = Int(item.quantity)
            }
            print("inventory loaded")
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }

    func loadPlots() {
        // load planted plots
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Plot>(entityName: "Plot")
        
        do {
            Plantings.plantings = try managedContext.fetch(fetchRequest)
            print("plots loaded")
            
            for planting in Plantings.plantings {
                let view = container.subviews.filter { $0.tag == Int(planting.id) }.first
                if let imageView = view as? UIImageView {
                    imageView.image = PlantManager.getStage(halfDaysOfCare: Int(planting.consecutiveDaysWatered), plant: Plant(rawValue: Int(planting.plant))!, lastWatered: planting.lastWatered, mature: planting.mature)
                    print(planting.consecutiveDaysWatered)
                    print(planting.lastWatered)
                }
            }
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func savePlanting(id: Int, plant: Int) {
        // save new planting
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        let newPlot = Plot(context: managedContext)
        
        newPlot.id = Int16(id)
        newPlot.plant = Int16(plant)
        newPlot.date = Date()
        
        Plantings.plantings.append(newPlot)
        
        do {
            try managedContext.save()
            print("saved planting")
        } catch {
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
    
    func deletePlanting(id: Int) {
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
            plot.consecutiveDaysWatered = 0
            print("new watering")
            
            // update images
            let view = container.subviews.filter { $0.tag == id }.first
            if let imageView = view as? UIImageView {
                imageView.image = PlantManager.getStage(halfDaysOfCare: Int(plot.consecutiveDaysWatered), plant: Plant(rawValue: Int(plot.plant))!, lastWatered: plot.lastWatered, mature: plot.mature)
                showEXP(near: imageView, exp: 5)
            }
        } else if PlantManager.needsWatering(date: plot.lastWatered) {
            // plant getting new watering date
            print("new watering date")
            
            if let lastWatered = plot.lastWatered {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour], from: lastWatered, to: Date())
                let diff = components.hour
                
                if let difference = diff {
                    print(difference)
                    if difference <= 12 {
                        var prevWatering = plot.consecutiveDaysWatered
                        let newWatering = prevWatering + 1
                        plot.consecutiveDaysWatered = newWatering
                        print(newWatering)
                    }
                }
            }
            
            plot.lastWatered = Date()
    
            // update images
            let view = container.subviews.filter { $0.tag == id }.first
            if let imageView = view as? UIImageView {
                imageView.image = PlantManager.getStage(halfDaysOfCare: Int(plot.consecutiveDaysWatered), plant: Plant(rawValue: Int(plot.plant))!, lastWatered: plot.lastWatered, mature: plot.mature)
                showEXP(near: imageView, exp: 5)
            }
        } else {
            print("no need for water")
            return
        }
        
        if PlantManager.currentStage == .seven && plot.mature == nil {
            plot.mature = Date()
        }
        
        // exp gain from watering
        updateEXP(with: 5)
        
        do {
            try managedContext.save()
            print("saved watering")
        } catch {
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
}
