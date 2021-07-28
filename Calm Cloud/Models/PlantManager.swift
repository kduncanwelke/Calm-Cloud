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
            case .rows, .multi, .planter, .lowPot:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .smallPot:
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
            case .geranium, .redTulip, .redGeranium, .yellowTulip, .pinkTulip, .whiteTulip, .daffodil, .aloe, .purplePetunia, .whitePetunia, .stripedPetunia, .blackPetunia, .bluePetunia:
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
            case .jade, .chard, .carrot, .strawberry, .pepper, .tomato, .zinnia, .lavendarZinnia, .salmonZinnia, .lobelia, .marigold, .paddle, .daisy, .cauliflower:
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
            case .lemon, .pumpkin, .lime, .squash, .watermelon, .kale, .orange, .eggplant:
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
                } else if halfDaysCaredFor >= 24 {
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
            // if five days have passed, plant reaches wilting stage
            if checkDiff(date: matureDate) >= 5 {
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
        case .kale:
            return kale
        case .orange:
            return orange
        case .daffodil:
            return daffodil
        case .zinnia:
            return zinnia
        case .lavendarZinnia:
            return lavendarZinnia
        case .salmonZinnia:
            return salmonZinnia
        case .aloe:
            return aloe
        case .paddle:
            return paddle
        case .marigold:
            return marigold
        case .lobelia:
            return lobelia
        case .purplePetunia:
            return purplePetunia
        case .whitePetunia:
            return whitePetunia
        case .stripedPetunia:
            return stripedPetunia
        case .blackPetunia:
            return blackPetunia
        case .bluePetunia:
            return bluePetunia
        case .daisy:
            return daisy
        case .cauliflower:
            return cauliflower
        case .eggplant:
            return eggplant
        case .none:
            return nil
        }
    }
    
    static func randomQuantity() -> Int {
        switch selected {
        // one plant
        case .aloe, .jade, .paddle, .redTulip, .redGeranium, .yellowTulip, .pinkTulip, .whiteTulip, .daffodil, .marigold, .daisy:
            return 1
        // one to three
        case .geranium, .purplePetunia, .whitePetunia, .stripedPetunia, .blackPetunia, .bluePetunia, .zinnia, .lavendarZinnia, .salmonZinnia, .lobelia:
            return Int.random(in: 1...3)
        // two to four
        case .chard, .cauliflower, .kale, .eggplant:
            return Int.random(in: 2...4)
        // three to six
        case .strawberry, .pepper, .tomato, .carrot:
            return Int.random(in: 3...6)
        // four to seven
        case .lemon, .pumpkin, .lime, .squash, .watermelon, .orange:
            return Int.random(in: 4...7)
        case .none:
            return 0
        }
    }
    
    static var currentStage: Stage = .one
    static var needsWater = false
    static var selected: Plant = .redTulip
    static var area: Area = .none
    static var buying: Seedling?
    
    static let emptyPlots = [#imageLiteral(resourceName: "emptyplot.png"),#imageLiteral(resourceName: "emptyplotbig.png"),#imageLiteral(resourceName: "emptyplotsmallpot.png"),#imageLiteral(resourceName: "emptyplottree.png")]
    static let maturePlants = [#imageLiteral(resourceName: "carrot7.png"),#imageLiteral(resourceName: "carrot7water.png"),#imageLiteral(resourceName: "chard7.png"),#imageLiteral(resourceName: "chard7water.png"),#imageLiteral(resourceName: "geranium7.png"),#imageLiteral(resourceName: "geranium7water.png"),#imageLiteral(resourceName: "jade7.png"),#imageLiteral(resourceName: "jade7water.png"),#imageLiteral(resourceName: "lemon7.png"),#imageLiteral(resourceName: "lemon7water.png"),#imageLiteral(resourceName: "lime7.png"),#imageLiteral(resourceName: "lime7water.png"),#imageLiteral(resourceName: "pepper7.png"),#imageLiteral(resourceName: "pepper7water.png"),#imageLiteral(resourceName: "pinktulip7.png"),#imageLiteral(resourceName: "pinktulip7water.png"),#imageLiteral(resourceName: "pumpkin7.png"),#imageLiteral(resourceName: "pumpkin7water.png"),#imageLiteral(resourceName: "redgeranium.png"),#imageLiteral(resourceName: "geranium7water.png"),#imageLiteral(resourceName: "redtulip7.png"),#imageLiteral(resourceName: "redtulip7water.png"),#imageLiteral(resourceName: "squash7.png"),#imageLiteral(resourceName: "squash7water.png"),#imageLiteral(resourceName: "strawberry7.png"),#imageLiteral(resourceName: "strawberry7water.png"),#imageLiteral(resourceName: "tomato7.png"),#imageLiteral(resourceName: "tomato7water.png"),#imageLiteral(resourceName: "watermelon7.png"),#imageLiteral(resourceName: "watermelon7water.png"),#imageLiteral(resourceName: "whitetulip7.png"),#imageLiteral(resourceName: "whitetulip7water.png"),#imageLiteral(resourceName: "yellowtulip7.png"),#imageLiteral(resourceName: "yellowtulip7water.png"),#imageLiteral(resourceName: "kale7.png"),#imageLiteral(resourceName: "kale7water.png"),#imageLiteral(resourceName: "orange7.png"),#imageLiteral(resourceName: "orange7water.png"),#imageLiteral(resourceName: "daffodil7.png"),#imageLiteral(resourceName: "daffodil7water.png"),#imageLiteral(resourceName: "lavendarzinnia7.png"),#imageLiteral(resourceName: "lavendarzinnia7water.png"),#imageLiteral(resourceName: "salmonzinnia7.png"),#imageLiteral(resourceName: "salmonzinnia7water.png"),#imageLiteral(resourceName: "zinnia7.png"),#imageLiteral(resourceName: "zinnia7water.png"),#imageLiteral(resourceName: "aloe7.png"),#imageLiteral(resourceName: "aloe7water.png"),#imageLiteral(resourceName: "paddle7.png"),#imageLiteral(resourceName: "paddle7water.png"),#imageLiteral(resourceName: "marigold7.png"),#imageLiteral(resourceName: "marigold7water.png"),#imageLiteral(resourceName: "lobelia7.png"),#imageLiteral(resourceName: "lobelia7water.png"),#imageLiteral(resourceName: "blackpetunia7.png"),#imageLiteral(resourceName: "blackpetunia7water.png"),#imageLiteral(resourceName: "bluepetunia7.png"),#imageLiteral(resourceName: "bluepetunia7water.png"),#imageLiteral(resourceName: "purplepetunia7.png"),#imageLiteral(resourceName: "purplepetunia7water.png"),#imageLiteral(resourceName: "stripedpetunia7.png"),#imageLiteral(resourceName: "stripedpetunia7water.png"),#imageLiteral(resourceName: "whitepetunia7.png"),#imageLiteral(resourceName: "whitepetunia7water.png"),#imageLiteral(resourceName: "daisy7.png"),#imageLiteral(resourceName: "daisy7water.png"),#imageLiteral(resourceName: "cauliflower7.png"),#imageLiteral(resourceName: "cauliflower7water.png"),#imageLiteral(resourceName: "eggplant7.png"),#imageLiteral(resourceName: "eggplant7water.png")]
    static let wiltedPlants = [#imageLiteral(resourceName: "aloe8.png"),#imageLiteral(resourceName: "carrot8.png"),#imageLiteral(resourceName: "chard8.png"),#imageLiteral(resourceName: "daffodil8.png"),#imageLiteral(resourceName: "geranium8.png"),#imageLiteral(resourceName: "jade8.png"),#imageLiteral(resourceName: "kale8.png"),#imageLiteral(resourceName: "lemon8.png"),#imageLiteral(resourceName: "lime8.png"),#imageLiteral(resourceName: "lobelia8.png"),#imageLiteral(resourceName: "marigold8.png"),#imageLiteral(resourceName: "orange8.png"),#imageLiteral(resourceName: "paddle8.png"),#imageLiteral(resourceName: "pepper8.png"),#imageLiteral(resourceName: "pumpkin8.png"),#imageLiteral(resourceName: "purplepetunia8.png"),#imageLiteral(resourceName: "redtulip8.png"),#imageLiteral(resourceName: "strawberry8.png"),#imageLiteral(resourceName: "tomato8.png"),#imageLiteral(resourceName: "watermelon8.png"),#imageLiteral(resourceName: "zinnia8.png"),#imageLiteral(resourceName: "daisy8.png"),#imageLiteral(resourceName: "cauliflower8.png"),#imageLiteral(resourceName: "eggplant8.png")]
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
    case kale       // 17
    case orange     // 18
    case daffodil   // 19
    case zinnia     // 20
    case lavendarZinnia // 21
    case salmonZinnia // 22
    case aloe       // 23
    case paddle     // 24
    case marigold   // 25
    case lobelia    // 26
    case purplePetunia // 27
    case whitePetunia // 28
    case stripedPetunia // 29
    case blackPetunia // 30
    case bluePetunia    // 31
    case daisy          // 32
    case cauliflower    // 33
    case eggplant       // 34
    case none       
}

enum Stage: Int {
    case zero, one, two, three, four, five, six, seven, eight
}
 
enum Area: String {
    case rows = "Rows"
    case lowPot = "Succulent Pot"
    case planter = "Raised Bed"
    case tallPot = "Tall Pot"
    case vegetablePlot = "Vegetable Plot"
    case smallPot = "Small Pot"
    case multi = "Rows/Raised Bed"
    case none = ""
}

