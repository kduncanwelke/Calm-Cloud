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
    static func getStage(date: Date?, plant: Plant) -> UIImage? {
        if let chosenDate = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: chosenDate, to: Date())
            let diff = components.hour
            // 24 48 72 96 120 144 168
            
            var stage: Int
            if let difference = diff {
                print(difference)
                if difference < 25 {
                    stage = 1
                } else if difference < 49 {
                    stage = 2
                } else if difference < 73 {
                    stage = 3
                } else if difference < 97 {
                    stage = 4
                } else if difference < 121 {
                    stage = 5
                } else if difference < 145 {
                    stage = 6
                } else if difference < 169 {
                    stage = 7
                } else {
                    stage = 0
                }
            } else {
                return nil
            }
            
            switch plant {
            case .redTulip:
                PlantManager.currentStage = Stage.init(rawValue: stage)!
                return redTulip
            }
        } else {
            return nil
        }
    }
    
    static var currentStage: Stage = .one
    static var selected: Plant = .redTulip
    
    static var redTulip: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                return #imageLiteral(resourceName: "redtulip1.png")
            case .two:
                return #imageLiteral(resourceName: "redtulip2.png")
            case .three:
                return #imageLiteral(resourceName: "redtulip3.png")
            case .four:
                return #imageLiteral(resourceName: "redtulip4.png")
            case .five:
                return #imageLiteral(resourceName: "redtulip5.png")
            case .six:
                return #imageLiteral(resourceName: "redtulip6.png")
            case .seven:
                return #imageLiteral(resourceName: "redtulip7.png")
            }
        }
    }
}

enum Plant: Int {
    case redTulip
}

enum Stage: Int {
    case zero, one, two, three, four, five, six, seven
}

struct Seedling {
    let name: String
    let image: UIImage
    let plant: Plant
}
