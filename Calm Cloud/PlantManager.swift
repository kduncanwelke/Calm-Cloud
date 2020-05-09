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
    static var currentStage: Stage = .one
    
    static var redTulip: UIImage {
        get {
            switch PlantManager.currentStage {
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


enum Stage {
    case one, two, three, four, five, six, seven
}
