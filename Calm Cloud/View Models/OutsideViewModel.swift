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
        } else if selectedPlot > 14 && selectedPlot < 18 {
            PlantManager.area = .lowPot
            print("bowl")
        } else if selectedPlot > 17 && selectedPlot < 21 {
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

}
