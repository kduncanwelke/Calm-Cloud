//
//  AnimationManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/24/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct AnimationManager {
 
    static var movingLeftAnimation: [UIImage] {
        get {
            switch AnimationManager.mood {
            case .happy:
                return [#imageLiteral(resourceName: "cloudkitty.png"),#imageLiteral(resourceName: "cloudkitty2.png")]
            case .unhappy:
                return [#imageLiteral(resourceName: "unhappy.png"),#imageLiteral(resourceName: "unhappy2.png")]
            case .sad:
                return [#imageLiteral(resourceName: "sad.png"),#imageLiteral(resourceName: "sad2.png")]
            case .thirsty:
                return [#imageLiteral(resourceName: "thirsty.png"),#imageLiteral(resourceName: "thirsty2.png")]
            case .hungry:
                return [#imageLiteral(resourceName: "hungry.png"),#imageLiteral(resourceName: "hungry2.png")]
            }
        }
    }
        
    static var movingRightAnimation: [UIImage] {
        get {
            switch AnimationManager.mood {
            case .happy:
                return [#imageLiteral(resourceName: "cloudkittyright.png"),#imageLiteral(resourceName: "cloudkittyright2.png")]
            case .unhappy:
                return [#imageLiteral(resourceName: "unhappyright.png"),#imageLiteral(resourceName: "unhappyright2.png")]
            case .sad:
                return [#imageLiteral(resourceName: "sadright.png"),#imageLiteral(resourceName: "sadright2.png")]
            case .thirsty:
                return [#imageLiteral(resourceName: "thirstyright.png"),#imageLiteral(resourceName: "thirstyright2.png")]
            case .hungry:
                return [#imageLiteral(resourceName: "hungryright.png"),#imageLiteral(resourceName: "hungryright2.png")]
            }
        }
    }
    
    static var bouncingAnimation: [UIImage] {
        get {
            switch AnimationManager.mood {
            case .happy:
                return [#imageLiteral(resourceName: "bounce1.png"),#imageLiteral(resourceName: "bounce2.png")]
            case .unhappy:
                return [#imageLiteral(resourceName: "unhappybounce.png"),#imageLiteral(resourceName: "unhappybounce2.png")]
            case .sad:
                return [#imageLiteral(resourceName: "sadbounce.png"),#imageLiteral(resourceName: "sadbounce2.png")]
            case .thirsty:
                return [#imageLiteral(resourceName: "thirstybounce.png"),#imageLiteral(resourceName: "thirstybounce2.png")]
            case .hungry:
                return [#imageLiteral(resourceName: "hungrybounce.png"),#imageLiteral(resourceName: "hungrybounce2.png")]
            }
        }
    }
    
    static let eatAnimation: [UIImage] = [#imageLiteral(resourceName: "eat1.png"),#imageLiteral(resourceName: "eat2.png")]
    static let drinkAnimation: [UIImage] = [#imageLiteral(resourceName: "drink1.png"),#imageLiteral(resourceName: "drink2.png")]
    static let sleepAnimation: [UIImage] = [#imageLiteral(resourceName: "sleep.png"),#imageLiteral(resourceName: "sleep2.png")]
    static let playAnimation: [UIImage] = [#imageLiteral(resourceName: "play1.png"),#imageLiteral(resourceName: "play2.png")]
    static let heartsAnimation: [UIImage] = [#imageLiteral(resourceName: "purr.png"),#imageLiteral(resourceName: "purr2.png"),#imageLiteral(resourceName: "purr3.png"),#imageLiteral(resourceName: "purr4.png")]
    
    static var status: Movement = .staying
    static var location: Location = .middle
    static var mood: Mood = .happy
    
    static var startImage: UIImage {
        get {
            switch AnimationManager.mood {
            case .happy:
                return #imageLiteral(resourceName: "cloudkitty.png")
            case .unhappy:
                return #imageLiteral(resourceName: "unhappy.png")
            case .sad:
                return #imageLiteral(resourceName: "sad.png")
            case .thirsty:
                return #imageLiteral(resourceName: "thirsty.png")
            case .hungry:
                return #imageLiteral(resourceName: "hungry.png")
            }
        }
    }
    
    static let toyAnimation: [UIImage] = [#imageLiteral(resourceName: "toy.png"),#imageLiteral(resourceName: "toy2.png")]
}

enum Movement {
    case movingLeft
    case movingRight
    case staying
}

enum Mood {
    case happy
    case unhappy
    case sad
    case thirsty
    case hungry
}

enum Location {
    case middle
    case food
    case water
    case bed
    case toy
}
