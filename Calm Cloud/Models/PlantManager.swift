//
//  PlantManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct PlantManager {
    static func needsWatering(date: Date?) -> Bool {
        if let chosenDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: chosenDate, to: Date())
            let diff = components.hour
            
            // if it's a new day plants can be watered (aka watering is reset)
            if calendar.isDateInToday(chosenDate) == false {
                return true
            }
            
            // allow watering every six hours
            if let difference = diff {
                if difference < 6 {
                    // plant has been watered within 6 hours
                    print("has been watered recently")
                    return false
                } else {
                    // plant has not been watered within 6 hours
                    print("needs water for this period")
                    return true
                }
            } else {
                // date with incalcuable difference (unlikely)
                return true
            }
        } else {
            // date is nil so plant has never been watered
            print("never watered, needs water")
            return true
        }
    }
    
    static func checkDiff(date: Date?) -> Int {
        if let chosenDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: chosenDate, to: Date())
            let diff = components.day
            
            if let difference = diff {
                print("mature diff \(difference)")
                return difference
            } else {
                print("difference zero")
                return 0
            }
        } else {
            print("date nil")
            return 0
        }
    }
    
    static func getStage(halfDaysOfCare: Int?, plant: Plant, lastWatered: Date?, mature: Date?) -> UIImage? {
        // used for if plant has beeen removed by harvesting or wilting
        if plant == .none {
            print("no plant")
            switch PlantManager.area {
            case .flowerStrips, .planter, .smallPot:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .lowPot:
                return #imageLiteral(resourceName: "emptyplotsmallpot.png")
            case .tallPot:
                return #imageLiteral(resourceName: "emptyplottree.png")
            case .vegetablePlot:
                return #imageLiteral(resourceName: "emptyplotbig.png")
            case .none:
                return nil
            }
        }
        
        // set stage of plant based on how many days it has received care
        var stage: Int
        
        // determine which stage of growth, half days of care because plants should be watered every 12 hours
        if let halfDaysCaredFor = halfDaysOfCare {
            switch plant {
            case .geranium, .redTulip, .redGeranium, .yellowTulip, .pinkTulip, .whiteTulip:
                // fast growers, take one week
                if halfDaysCaredFor <= 2 {
                    stage = 1
                } else if halfDaysCaredFor > 2 && halfDaysCaredFor <= 4 {
                    stage = 2
                } else if halfDaysCaredFor > 4 && halfDaysCaredFor <= 6  {
                    stage = 3
                } else if halfDaysCaredFor > 6 && halfDaysCaredFor <= 8 {
                    stage = 4
                } else if halfDaysCaredFor > 8 && halfDaysCaredFor <= 10 {
                    stage = 5
                } else if halfDaysCaredFor > 10 && halfDaysCaredFor <= 12 {
                    stage = 6
                } else if halfDaysCaredFor >= 12 {
                    stage = 7
                } else {
                    stage = 0
                }
            case .jade, .chard, .carrot, .strawberry, .pepper, .tomato:
                // medium growers take ten days
                if halfDaysCaredFor <= 2 {
                    stage = 1
                } else if halfDaysCaredFor > 2 && halfDaysCaredFor <= 4 {
                    stage = 2
                } else if halfDaysCaredFor > 4 && halfDaysCaredFor <= 6  {
                    stage = 3
                } else if halfDaysCaredFor > 6 && halfDaysCaredFor <= 10 {
                    stage = 4
                } else if halfDaysCaredFor > 10 && halfDaysCaredFor <= 16 {
                    stage = 5
                } else if halfDaysCaredFor > 16 && halfDaysCaredFor <= 20 {
                    stage = 6
                } else if halfDaysCaredFor >= 20 {
                    stage = 7
                } else {
                    stage = 0
                }
            case .lemon, .pumpkin, .lime, .squash, .watermelon:
                // slow growers take two weeks
                if halfDaysCaredFor <= 2 {
                    stage = 1
                } else if halfDaysCaredFor > 2 && halfDaysCaredFor <= 6 {
                    stage = 2
                } else if halfDaysCaredFor > 6 && halfDaysCaredFor <= 10 {
                    stage = 3
                } else if halfDaysCaredFor > 10 && halfDaysCaredFor <= 14 {
                    stage = 4
                } else if halfDaysCaredFor > 14 && halfDaysCaredFor <= 20 {
                    stage = 5
                } else if halfDaysCaredFor > 20 && halfDaysCaredFor <= 24 {
                    stage = 6
                } else if halfDaysCaredFor >= 28 {
                    stage = 7
                } else {
                    stage = 0
                }
            case .none:
                return nil
            }
        } else {
            return nil
        }
        
        // if plant has reached maturity, check how many days have passed
        if let matureDate = mature {
            print("mature")
            // if four days have passed, plant reaches wilting stage
            if checkDiff(date: matureDate) == 4 {
                stage = 8
            }
        } 
        
        // set current stage to use for plant
        PlantManager.currentStage = Stage.init(rawValue: stage)!
        
        // determine if plant needs water
        if PlantManager.currentStage == .eight {
            // if plant is on last stage (wilted) it does not require water
            PlantManager.needsWater = false
        } else {
            PlantManager.needsWater = PlantManager.needsWatering(date: lastWatered)
        }
        
        // determine which plant art is needed
        switch plant {
        case .redTulip:
            return redTulip
        case .jade:
            return jade
        case .chard:
            return chard
        case .lemon:
            return lemon
        case .pumpkin:
            return pumpkin
        case .geranium:
            return geranium
        case .redGeranium:
            return redGeranium
        case .yellowTulip:
            return yellowTulip
        case .pinkTulip:
            return pinkTulip
        case .whiteTulip:
            return whiteTulip
        case .lime:
            return lime
        case .carrot:
            return carrot
        case .squash:
            return squash
        case .strawberry:
            return strawberry
        case .watermelon:
            return watermelon
        case .pepper:
            return pepper
        case .tomato:
            return tomato
        case .none:
            return nil
        }
    }
    
    static var chosen = 0
    static var currentStage: Stage = .one
    static var needsWater = false
    static var selected: Plant = .redTulip
    static var area: Area = .none
    
    static let emptyPlots = [#imageLiteral(resourceName: "emptyplot.png"),#imageLiteral(resourceName: "emptyplotbig.png"),#imageLiteral(resourceName: "emptyplotsmallpot.png"),#imageLiteral(resourceName: "emptyplottree.png")]
    static let maturePlants = [#imageLiteral(resourceName: "carrot7.png"),#imageLiteral(resourceName: "carrot7water.png"),#imageLiteral(resourceName: "chard7.png"),#imageLiteral(resourceName: "chard7water.png"),#imageLiteral(resourceName: "geranium7.png"),#imageLiteral(resourceName: "geranium7water.png"),#imageLiteral(resourceName: "jade7.png"),#imageLiteral(resourceName: "jade7water.png"),#imageLiteral(resourceName: "lemon7.png"),#imageLiteral(resourceName: "lemon7water.png"),#imageLiteral(resourceName: "lime7.png"),#imageLiteral(resourceName: "lime7water.png"),#imageLiteral(resourceName: "pepper7.png"),#imageLiteral(resourceName: "pepper7water.png"),#imageLiteral(resourceName: "pinktulip7.png"),#imageLiteral(resourceName: "pinktulip7water.png"),#imageLiteral(resourceName: "pumpkin7.png"),#imageLiteral(resourceName: "pumpkin7water.png"),#imageLiteral(resourceName: "redgeranium.png"),#imageLiteral(resourceName: "redgeraniumwater.png"),#imageLiteral(resourceName: "redtulip7.png"),#imageLiteral(resourceName: "redtulip7water.png"),#imageLiteral(resourceName: "squash7.png"),#imageLiteral(resourceName: "squash7water.png"),#imageLiteral(resourceName: "strawberry7.png"),#imageLiteral(resourceName: "strawberry7water.png"),#imageLiteral(resourceName: "tomato7.png"),#imageLiteral(resourceName: "tomato7water.png"),#imageLiteral(resourceName: "watermelon7.png"),#imageLiteral(resourceName: "watermelon7water.png"),#imageLiteral(resourceName: "whitetulip7.png"),#imageLiteral(resourceName: "whitetulip7water.png"),#imageLiteral(resourceName: "yellowtulip7.png"),#imageLiteral(resourceName: "yellowtulip7water.png")]
    static let wiltedPlants = [#imageLiteral(resourceName: "carrot8.png"),#imageLiteral(resourceName: "chard8.png"),#imageLiteral(resourceName: "geranium8.png"),#imageLiteral(resourceName: "jade8.png"),#imageLiteral(resourceName: "lemon8.png"),#imageLiteral(resourceName: "lime8.png"),#imageLiteral(resourceName: "pepper8.png"),#imageLiteral(resourceName: "pumpkin8.png"),#imageLiteral(resourceName: "redtulip8.png"),#imageLiteral(resourceName: "strawberry8.png"),#imageLiteral(resourceName: "tomato8.png"),#imageLiteral(resourceName: "watermelon8.png")]
}

enum Plant: Int {
    case redTulip   // 0
    case jade       // 1
    case chard      // 2
    case lemon      // 3
    case pumpkin    // 4
    case geranium   // 5
    case redGeranium // 6
    case yellowTulip // 7
    case pinkTulip  // 8
    case whiteTulip // 9
    case lime       // 10
    case carrot     // 11
    case squash     // 12
    case strawberry // 13
    case watermelon // 14
    case pepper     // 15
    case tomato     // 16
    case none       
}

enum Stage: Int {
    case zero, one, two, three, four, five, six, seven, eight
}
 
enum Area {
    case flowerStrips
    case lowPot
    case planter
    case tallPot
    case vegetablePlot
    case smallPot
    case none
}

