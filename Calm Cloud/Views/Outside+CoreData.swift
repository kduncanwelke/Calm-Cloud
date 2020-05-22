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
        var fetchRequest = NSFetchRequest<Inventory>(entityName: "Inventory")
        
        do {
            var result = try managedContext.fetch(fetchRequest)
            if let inventory = result.first {
                Plantings.loaded = inventory
                Plantings.availableSeedlings[.chard] = Int(inventory.chards)
                Plantings.availableSeedlings[.geranium] = Int(inventory.pinkGeraniums)
                Plantings.availableSeedlings[.jade] = Int(inventory.jades)
                Plantings.availableSeedlings[.lemon] = Int(inventory.lemons)
                Plantings.availableSeedlings[.pumpkin] = Int(inventory.pumpkins)
                Plantings.availableSeedlings[.redTulip] = Int(inventory.redTulips)
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
        
        guard let toDelete = planting else { return }
        
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
                    if difference <= 12 {
                        plot.consecutiveDaysWatered += 1
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
