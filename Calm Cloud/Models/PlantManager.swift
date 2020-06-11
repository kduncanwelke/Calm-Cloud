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
            if Recentness.isNewDay() {
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
                return difference
            } else {
                return 0
            }
        } else {
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
        
        // if plant has reached maturity, check how many days have passed
        if let matureDate = mature {
            print("mature")
            // if four days have passed, plant reaches wilting stage
            if checkDiff(date: matureDate) >= 4 {
                stage = 8
            }
        }
        
        // determine which stage of growth, half days of care because plants should be watered every 12 hours
        if let halfDaysCaredFor = halfDaysOfCare {
            print(halfDaysOfCare)
            if halfDaysCaredFor == 0 {
                stage = 1
            } else if halfDaysCaredFor <= 2 {
                stage = 2
            } else if halfDaysCaredFor <= 4 {
                stage = 3
            } else if halfDaysCaredFor <= 6 {
                stage = 4
            } else if halfDaysCaredFor <= 8 {
                stage = 5
            } else if halfDaysCaredFor <= 10 {
                stage = 6
            } else if halfDaysCaredFor >= 12 {
                stage = 7
            } else {
                stage = 0
            }
        } else {
            return nil
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
        case .none:
            return nil
        }
    }
    
    static var chosen = 0
    static var currentStage: Stage = .one
    static var needsWater = false
    static var selected: Plant = .redTulip
    static var area: Area = .none
    
    // MARK: Red tulip
    
    static var redTulip: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip1.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip2.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip3.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip4.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip5.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip6.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "redtulip7.png")
                } else {
                    return #imageLiteral(resourceName: "redtulip7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "redtulip8.png")
            }
        }
    }
    
    // MARK: Jade
    
    static var jade: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "jade1.png")
                } else {
                    return #imageLiteral(resourceName: "jade1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "jade2.png")
                } else {
                    return #imageLiteral(resourceName: "jade2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "jade3.png")
                } else {
                    return #imageLiteral(resourceName: "jade3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "jade4.png")
                } else {
                    return #imageLiteral(resourceName: "jade4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "jade5.png")
                } else {
                    return #imageLiteral(resourceName: "jade5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "jade6.png")
                } else {
                    return #imageLiteral(resourceName: "jade6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "jade7.png")
                } else {
                    return #imageLiteral(resourceName: "jade7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "jade8.png")
            }
        }
    }
    
    // MARK: Chard
    
    static var chard: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "chard1.png")
                } else {
                    return #imageLiteral(resourceName: "chard1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "chard2.png")
                } else {
                    return #imageLiteral(resourceName: "chard2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "chard3.png")
                } else {
                    return #imageLiteral(resourceName: "chard3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "chard4.png")
                } else {
                    return #imageLiteral(resourceName: "chard4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "chard5.png")
                } else {
                    return #imageLiteral(resourceName: "chard5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "chard6.png")
                } else {
                    return #imageLiteral(resourceName: "chard6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "chard7.png")
                } else {
                    return #imageLiteral(resourceName: "chard7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "chard8.png")
            }
        }
    }
    
    // MARK: Lemon
    
    static var lemon: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplottree.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon1.png")
                } else {
                    return #imageLiteral(resourceName: "lemon1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon2.png")
                } else {
                    return #imageLiteral(resourceName: "lemon2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon3.png")
                } else {
                    return #imageLiteral(resourceName: "lemon3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon4.png")
                } else {
                    return #imageLiteral(resourceName: "lemon4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon5.png")
                } else {
                    return #imageLiteral(resourceName: "lemon5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon6.png")
                } else {
                    return #imageLiteral(resourceName: "lemon6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "lemon7.png")
                } else {
                    return #imageLiteral(resourceName: "lemon7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "lemon8.png")
            }
        }
    }
    
    // MARK: Pumpkin
    
    static var pumpkin: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplotbig.png")
            case .one:
                if needsWater {
                 return #imageLiteral(resourceName: "pumpkin1.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "pumpkin2.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "pumpkin3.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "pumpkin4.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "pumpkin5.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "pumpkin6.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "pumpkin7.png")
                } else {
                    return #imageLiteral(resourceName: "pumpkin7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "pumpkin8.png")
            }
        }
    }
    
    // MARK: Geranium
    
    static var geranium: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplotsmallpot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium1.png")
                } else {
                    return #imageLiteral(resourceName: "geranium1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium2.png")
                } else {
                    return #imageLiteral(resourceName: "geranium2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium3.png")
                } else {
                    return #imageLiteral(resourceName: "geranium3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium4.png")
                } else {
                    return #imageLiteral(resourceName: "geranium4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium5.png")
                } else {
                    return #imageLiteral(resourceName: "geranium5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium6.png")
                } else {
                    return #imageLiteral(resourceName: "geranium6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "geranium7.png")
                } else {
                    return #imageLiteral(resourceName: "geranium7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "geranium8.png")
            }
        }
    }
    
    static let emptyPlots = [#imageLiteral(resourceName: "emptyplot.png"),#imageLiteral(resourceName: "emptyplotbig.png"),#imageLiteral(resourceName: "emptyplotsmallpot.png"),#imageLiteral(resourceName: "emptyplottree.png")]
    static let maturePlants = [#imageLiteral(resourceName: "chard7.png"),#imageLiteral(resourceName: "chard7water.png"),#imageLiteral(resourceName: "geranium7.png"),#imageLiteral(resourceName: "geranium7water.png"),#imageLiteral(resourceName: "jade7.png"),#imageLiteral(resourceName: "jade7water.png"),#imageLiteral(resourceName: "lemon7.png"),#imageLiteral(resourceName: "lemon7water.png"),#imageLiteral(resourceName: "pumpkin7.png"),#imageLiteral(resourceName: "pumpkin7water.png"),#imageLiteral(resourceName: "redtulip7.png"),#imageLiteral(resourceName: "redtulip7water.png")]
    static let wiltedPlants = [#imageLiteral(resourceName: "chard8.png"),#imageLiteral(resourceName: "geranium8.png"),#imageLiteral(resourceName: "jade8.png"),#imageLiteral(resourceName: "lemon8.png"),#imageLiteral(resourceName: "pumpkin8.png"),#imageLiteral(resourceName: "redtulip8.png")]
}

enum Plant: Int {
    case redTulip
    case jade
    case chard
    case lemon
    case pumpkin
    case geranium
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

