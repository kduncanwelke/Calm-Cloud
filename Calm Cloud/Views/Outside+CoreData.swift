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
    
    func loadPlots() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Plot>(entityName: "Plot")
        
        do {
            Plantings.plantings = try managedContext.fetch(fetchRequest)
            print("plots loaded")
            
            for planting in Plantings.plantings {
                let view = container.subviews.filter { $0.tag == Int(planting.id) }.first
                if let imageView = view as? UIImageView {
                    imageView.image = PlantManager.getStage(date: planting.date, plant: Plant(rawValue: Int(planting.plant))!)
                }
            }
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func savePlanting(id: Int, plant: Int) {
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
    
}
