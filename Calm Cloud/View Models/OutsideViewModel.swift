//
//  OutsideViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/28/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class OutsideViewModel {

    // MARK: Plantings

    func setName() {
        let planting = Plantings.plantings.filter { $0.id == Plantings.currentPlot }.first

        guard let plant = planting else { return }

        for seedling in Plantings.seedlings {
            if seedling.plant == Plant(rawValue: Int(plant.plant))! {
                Plantings.currentPlantName = seedling.name
            }
        }
    }

    func getPlot() -> Plot? {
        return Plantings.plantings.filter { $0.id == Plantings.currentPlot }.first
    }

    func getPlant() -> UIImage? {
        return PlantManager.getStage(halfDaysOfCare: 0, plant: PlantManager.selected, lastWatered: nil, mature: nil)
    }

    func getStage(plot: Plot) -> UIImage? {
        return PlantManager.getStage(halfDaysOfCare: Int(plot.consecutiveWaterings), plant: Plant(rawValue: Int(plot.plant))!, lastWatered: plot.lastWatered, mature: plot.mature)
    }

    func getDaysLeft() -> (name: String, days: Int) {
        let planting = Plantings.plantings.filter { $0.id == Plantings.currentPlot }.first

        guard let plant = planting else { return ("", 0) }

        for seedling in Plantings.seedlings {
            if seedling.plant == Plant(rawValue: Int(plant.plant))! {
                Plantings.currentPlantName = seedling.name
            }
        }

        let daysLeft = PlantManager.checkDiff(date: plant.mature)
        print(daysLeft)
        var days = 5 - daysLeft

        return (Plantings.currentPlantName, days)
    }

    func removePlant() -> UIImage? {
        return PlantManager.getStage(halfDaysOfCare: nil, plant: .none, lastWatered: nil, mature: nil)
    }

    func saveInventory() {
        DataFunctions.saveInventory()
    }

    func harvest() {
        // update count and save
        Harvested.basketCounts[PlantManager.selected]! += 1
        DataFunctions.saveHarvest()
    }

    func setPlot(plot: Int) {
        Plantings.currentPlot = plot
    }

    func getName() -> String {
        return Plantings.currentPlantName
    }

    func setPlotArea() {
        var selectedPlot = Plantings.currentPlot
        
        if selectedPlot < 15 {
            PlantManager.area = .rows
            print("flower strip")
        } else if selectedPlot >= 15 && selectedPlot < 18 {
            PlantManager.area = .lowPot
            print("bowl")
        } else if selectedPlot >= 18 && selectedPlot < 21 {
            PlantManager.area = .planter
            print("planter")
        } else if selectedPlot == 21 {
            PlantManager.area = .tallPot
            print("tall pot")
        } else if selectedPlot == 28 {
            PlantManager.area = .smallPot
            print("small pot")
        } else {
            PlantManager.area = .vegetablePlot
            print("vegetable plot")
        }
    }

    func getPlot() -> Int {
        return Plantings.currentPlot
    }

    func resetArea() {
        PlantManager.area = .none
    }

    func getPlotIDs() -> [Int] {
        var ids: [Int] = []

        for planting in Plantings.plantings {
            ids.append(Int(planting.id))
        }

        return ids
    }

    func getPlots(index: Int) -> Plot {
        return Plantings.plantings[index]
    }

    func handlePlantTap(image: UIImageView) -> Message? {
        switch StatusManager.mode {
        case .planting:
            // determine if plot is empty
            if image.isMatch(with: PlantManager.emptyPlots) {
                return .message
            } else if image.isMatch(with: PlantManager.maturePlants) {
                // harvest prompt for mature plants
                print("mature plant")
                setPlot(plot: image.tag)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                return .harvest
            } else {
                // otherwise simply show identification
                setPlot(plot: image.tag)
                setName()
                return .identity
            }
        case .watering:
            if image.isMatch(with: PlantManager.wiltedPlants) {
                // cannot water wilted plant
                return nil
            } else {
                setPlot(plot: image.tag)
                saveWatering(id: image.tag)
                // no message
                return .water
            }
        case .removal:
            setPlot(plot: image.tag)

            // determine if plot has wilted plant
            if image.isMatch(with: PlantManager.wiltedPlants) {
                print("wilted plant")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadWilted"), object: nil)
                return .remove
            } else if !image.isMatch(with: PlantManager.emptyPlots) {
                // make sure plot is not empty
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadRemove"), object: nil)
                return .remove
            } else {
                return nil
            }
        }
    }

    // MARK: Level

    func canAccessLanterns() -> Bool {
        if LevelManager.currentLevel >= LevelManager.lanternsUnlock {
            return true
        } else {
            return false
        }
    }

    // MARK: Lanterns

    func lanternsOn() -> Bool {
        StatusManager.lanternsOn
    }

    func turnLanternsOff() {
        StatusManager.lanternsOn = false
    }

    func turnLanternsOn() {
        StatusManager.lanternsOn = true
    }

    // MARK: Honor stand

    func hasEarnings() -> Bool {
        if MoneyManager.earnings != 0 {
            return true
        } else {
            return false
        }
    }

    func earningsTotal() -> Int {
        return MoneyManager.earnings
    }

    func addEarnings() {
        MoneyManager.total += MoneyManager.earnings
       
        // clear out earnings
        MoneyManager.earnings = 0

        // resave money
        DataFunctions.saveMoney()
    }

    func configureHonorStand(honorStandImages: [UIImageView]) -> (hidden: Bool, imagesForHonorStand: [UIImageView]) {
        var index = 0

        // show more crowded image if more quantity
        for (type, quantity) in Harvested.inStand {
            if honorStandImages[index].image == nil {
                if quantity > 0 {
                    honorStandImages[index].image = Harvested.getStandImage(plant: type)
                    index += 1
                }
            }
        }

        if MoneyManager.earnings != 0 {
            return (false, honorStandImages)
        } else {
            return (true, honorStandImages)
        }
    }

    func hideMoneyInHonorStand() -> Bool {
        if let income = Harvested.randomPurchases() {
            // show collectable money
            MoneyManager.earnings += income

            if income != 0 {
                DataFunctions.saveMoney()
                DataFunctions.saveHonorStandItems()
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }

    // MARK: Weather

    func configureWeather() -> (condition: WeatherCondition, image: UIImage?) {
        // change background if night
        let hour = Calendar.current.component(.hour, from: Date())

        switch WeatherManager.currentWeather {
        case .clearWarm:
            if hour > 6 && hour < 20 {
                return (.nothing, UIImage(named: "outside"))
            } else {
                return (.nothing, UIImage(named: "backgroundnight"))
            }
        case .clearCool:
            if hour > 6 && hour < 20 {
                return (.nothing, UIImage(named: "outsidefall"))
            } else {
                return (.nothing, UIImage(named: "outsidefallnight"))
            }
        case .rainingWarm:
            if hour > 6 && hour < 20 {
                return (.rain, UIImage(named: "outside"))
            } else {
                return (.rain, UIImage(named: "backgroundnight"))
            }
        case .rainingCool:
            if hour > 6 && hour < 20 {
                return (.rain, UIImage(named: "outsidefall"))
            } else {
                return (.rain, UIImage(named: "outsidefallnight"))
            }
        case .snowing:
            if hour > 6 && hour < 20 {
                return (.snow, UIImage(named: "outsidesnow"))
            } else {
                return (.snow, UIImage(named: "outsidesnownight"))
            }
        case .snowOnGround:
            if hour > 6 && hour < 20 {
                return (.nothing, UIImage(named: "outsidesnow"))
            } else {
                return (.nothing, UIImage(named: "outsidesnownight"))
            }
        }
    }

    // MARK: Sound

    func setAmbientSound() {
        let hour = Calendar.current.component(.hour, from: Date())

        switch WeatherManager.currentWeather {
        case .clearWarm:
            if hour > 6 && hour < 20 {
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.outside.resourceName, type: Sounds.outside.type)
                Sound.startPlaying()
            } else {
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.night.resourceName, type: Sounds.night.type)
                Sound.startPlaying()
            }
        case .clearCool:
            if hour > 6 && hour < 20 {
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.outsideFallWinter.resourceName, type: Sounds.outsideFallWinter.type)
                Sound.startPlaying()
            } else {
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.outsideFallWinterNight.resourceName, type: Sounds.outsideFallWinterNight.type)
                Sound.startPlaying()
            }
        case .rainingWarm:
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.rainOutdoors.resourceName, type: Sounds.rainOutdoors.type)
            Sound.startPlaying()
        case .rainingCool:
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.rainOutdoors.resourceName, type: Sounds.rainOutdoors.type)
            Sound.startPlaying()
        case .snowing:
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.snow.resourceName, type: Sounds.snow.type)
            Sound.startPlaying()
        case .snowOnGround:
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.snow.resourceName, type: Sounds.snow.type)
            Sound.startPlaying()
        }
    }

    // MARK: Core Data

    func saveMoney() {
        DataFunctions.saveMoney()
    }

    // MARK: Animation

    func isReturnedFromSegue() -> Bool {
        return StatusManager.returnedFromSegueOutside
    }

    func setReturnFromSegue() {
        StatusManager.returnedFromSegueOutside = true
    }

    func removeReturnFromSegue() {
        StatusManager.returnedFromSegueOutside = false
    }

    func setOutsidePosition() {
        AnimationManager.outsideLocation = .gate
        AnimationManager.movement = .staying
    }

    func isStopped() -> Bool {
        return StatusManager.outsideStopped
    }

    func stopOutside() {
        StatusManager.outsideStopped = true
    }

    func resumeOutside() {
        StatusManager.outsideStopped = false
    }

    // MARK: Mode

    func setMode(button: Mode) {
        switch button {
        case .planting:
            StatusManager.mode = .planting
        case .removal:
            StatusManager.mode = .removal
        case .watering:
            StatusManager.mode = .watering
        }
    }

    func prevMode() -> Mode {
        return StatusManager.mode
    }
}
