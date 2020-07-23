//
//  AnimationManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/24/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

// manage cloud kitty animations
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
            case .embarrassed:
                return [#imageLiteral(resourceName: "embarrassed.png"),#imageLiteral(resourceName: "embarrassed2.png")]
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
            case .embarrassed:
                return [#imageLiteral(resourceName: "embarrassedright1.png"),#imageLiteral(resourceName: "embarrassedright2.png")]
            }
        }
    }
    
    static var lingerAnimation: [UIImage] {
        get {
            switch AnimationManager.mood {
            case .happy:
                return [#imageLiteral(resourceName: "cloudkitty.png"),#imageLiteral(resourceName: "cloudkittyright.png")]
            case .unhappy:
                return [#imageLiteral(resourceName: "unhappy.png"),#imageLiteral(resourceName: "unhappyright.png")]
            case .sad:
                return [#imageLiteral(resourceName: "sad.png"),#imageLiteral(resourceName: "sadright.png")]
            case .thirsty:
                return [#imageLiteral(resourceName: "thirsty.png"),#imageLiteral(resourceName: "thirstyright.png")]
            case .hungry:
                return [#imageLiteral(resourceName: "hungry.png"),#imageLiteral(resourceName: "hungryright.png")]
            case .embarrassed:
                return [#imageLiteral(resourceName: "embarrassed.png"),#imageLiteral(resourceName: "embarrassedright1.png")]
            }
        }
    }
    
    static var bouncingAnimation: [UIImage] {
        get {
            let range = [1,2]
            let animation = range.randomElement()
            
            switch AnimationManager.mood {
            case .happy:
                if animation == 1 {
                    if AnimationManager.location == .ceiling {
                        return [#imageLiteral(resourceName: "upsidedownbounce1.png"),#imageLiteral(resourceName: "upsidedownbounce2.png")]
                    } else {
                        return [#imageLiteral(resourceName: "bounce1.png"),#imageLiteral(resourceName: "bounce2.png")]
                    }
                } else {
                    if AnimationManager.location == .ceiling {
                        return [#imageLiteral(resourceName: "upsidedownbounceright1.png"),#imageLiteral(resourceName: "upsidedownbounceright2.png")]
                    } else {
                        return [#imageLiteral(resourceName: "bounceright1.png"),#imageLiteral(resourceName: "bounceright2.png")]
                    }
                }
            case .unhappy:
                if animation == 1 {
                    return [#imageLiteral(resourceName: "unhappybounce.png"),#imageLiteral(resourceName: "unhappybounce2.png")]
                } else {
                    return [#imageLiteral(resourceName: "unhappybounceright1.png"),#imageLiteral(resourceName: "unhappybounceright2.png")]
                }
            case .sad:
                if animation == 1 {
                    return [#imageLiteral(resourceName: "sadbounce.png"),#imageLiteral(resourceName: "sadbounce2.png")]
                } else {
                    return [#imageLiteral(resourceName: "sadbounceright1.png"),#imageLiteral(resourceName: "sadbounceright2.png")]
                }
            case .thirsty:
                if animation == 1 {
                    return [#imageLiteral(resourceName: "thirstybounce.png"),#imageLiteral(resourceName: "thirstybounce2.png")]
                } else {
                    return [#imageLiteral(resourceName: "thirstybounceright1.png"),#imageLiteral(resourceName: "thirstybounceright2.png")]
                }
            case .hungry:
                if animation == 1 {
                    return [#imageLiteral(resourceName: "hungrybounce.png"),#imageLiteral(resourceName: "hungrybounce2.png")]
                } else {
                    return [#imageLiteral(resourceName: "hungrybounceright1.png"),#imageLiteral(resourceName: "hungrybounceright2.png")]
                }
            case .embarrassed:
                if animation == 1 {
                    return [#imageLiteral(resourceName: "embarrassedbounce1.png"),#imageLiteral(resourceName: "embarrassedbounce2.png")]
                } else {
                    return [#imageLiteral(resourceName: "embarrassedbounceright1.png"),#imageLiteral(resourceName: "embarrassedbounceright2.png")]
                }
            }
        }
    }
    
    static let eatAnimation: [UIImage] = [#imageLiteral(resourceName: "eat1.png"),#imageLiteral(resourceName: "eat2.png")]
    static let drinkAnimation: [UIImage] = [#imageLiteral(resourceName: "drink1.png"),#imageLiteral(resourceName: "drink2.png")]
    static let playAnimation: [UIImage] = [#imageLiteral(resourceName: "play1.png"),#imageLiteral(resourceName: "play2.png")]
    static let digAnimation: [UIImage] = [#imageLiteral(resourceName: "dig.png"),#imageLiteral(resourceName: "dig2.png"),#imageLiteral(resourceName: "dig3.png"),#imageLiteral(resourceName: "dig4.png")]
    static let petAnimation: [UIImage] = [#imageLiteral(resourceName: "purr.png"),#imageLiteral(resourceName: "purr2.png")]
    
    static let upsideDownLeft: [UIImage] = [#imageLiteral(resourceName: "upsidedown1.png"),#imageLiteral(resourceName: "upsidedown2.png")]
    static let upsideDownRight: [UIImage] = [#imageLiteral(resourceName: "upsidedownright1.png"),#imageLiteral(resourceName: "upsidedownright2.png")]
    
    static var sleepAnimation: [UIImage] {
        get {
            let range = [1,2]
            let animation = range.randomElement()
            
            if animation == 1 {
                return [#imageLiteral(resourceName: "sleep.png"),#imageLiteral(resourceName: "sleep2.png")]
            } else {
                return [#imageLiteral(resourceName: "sleepright.png"),#imageLiteral(resourceName: "sleepright2.png")]
            }
        }
    }
    
    static let playGameAnimation: [UIImage] = [#imageLiteral(resourceName: "cloudkitty.png"),#imageLiteral(resourceName: "playleft.png")]
    
    static var movement: Movement = .staying
    static var location: Location = .middle
    static var outsideLocation: OutsideLocation = .back
    
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
            case .embarrassed:
                return #imageLiteral(resourceName: "embarrassed.png")
            }
        }
    }
    
    static let toyAnimation: [UIImage] = [#imageLiteral(resourceName: "toy.png"),#imageLiteral(resourceName: "toy2.png")]
    static let revealAnimation: [UIImage] = [#imageLiteral(resourceName: "cloudkittyright.png"),#imageLiteral(resourceName: "play2.png")]
    static let gameAnimation: [UIImage] = [#imageLiteral(resourceName: "game1.png"),#imageLiteral(resourceName: "game2.png"),#imageLiteral(resourceName: "game3.png"),#imageLiteral(resourceName: "game4.png"),#imageLiteral(resourceName: "game5.png")]
}

enum Movement {
    case moving
    case staying
}

enum Mood {
    case happy
    case unhappy
    case sad
    case thirsty
    case hungry
    case embarrassed
}

enum Location {
    case middle
    case food
    case water
    case bed
    case toy
    case potty
    case ceiling
    case game
}

enum OutsideLocation {
    case ceiling
    case planter
    case front
    case back
    case gate
    case pot
    case pots
}
