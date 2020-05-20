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
            let isSameDay = calendar.isDate(chosenDate, inSameDayAs: Date())
           
            if isSameDay {
                // plant has been watered within this day
                print("same day no need for water")
                return false
            } else {
                // plant has not been watered within this day
                print("new day needs water")
                return true
            }
        } else {
            // date is nil so plant has never been watered
            print("never watered, needs water")
            return true
        }
    }
    
    static func getStage(daysOfCare: Int?, plant: Plant, lastWatered: Date?) -> UIImage? {
        var stage: Int
        if let daysCaredFor = daysOfCare {
            if daysCaredFor == 0 {
                stage = 1
            } else if daysCaredFor == 1 {
                stage = 2
            } else if daysCaredFor == 2 {
                stage = 3
            } else if daysCaredFor == 3 {
                stage = 4
            } else if daysCaredFor == 4 {
                stage = 5
            } else if daysCaredFor == 5 {
                stage = 6
            } else if daysCaredFor >= 6 {
                stage = 7
            } else {
                stage = 0
            }
        } else {
            return nil
        }
            
        PlantManager.currentStage = Stage.init(rawValue: stage)!
        PlantManager.needsWater = PlantManager.needsWatering(date: lastWatered)
        
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
        }
    }
    
    static var currentStage: Stage = .one
    static var needsWater = false
    static var selected: Plant = .redTulip
    static var area: Area = .none
    
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
            }
        }
    }
    
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
            }
        }
    }
    
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
            }
        }
    }
    
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
            }
        }
    }
    
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
            }
        }
    }
    
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
            }
        }
    }
}

enum Plant: Int {
    case redTulip
    case jade
    case chard
    case lemon
    case pumpkin
    case geranium
}

enum Stage: Int {
    case zero, one, two, three, four, five, six, seven
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

struct Seedling {
    let name: String
    let image: UIImage
    let plant: Plant
    let allowedArea: Area
}
