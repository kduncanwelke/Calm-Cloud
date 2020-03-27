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
 
    static let movingLeftAnimation: [UIImage] = [#imageLiteral(resourceName: "cloudkitty.png"),#imageLiteral(resourceName: "cloudkitty2.png")]
    static let movingRightAnimation: [UIImage] = [#imageLiteral(resourceName: "cloudkittyright.png"),#imageLiteral(resourceName: "cloudkittyright2.png")]
    static let bouncingAnimation: [UIImage] = [#imageLiteral(resourceName: "bounce1.png"),#imageLiteral(resourceName: "bounce2.png")]
    static var status: Movement = .staying
    static var location: Location = .middle
    
    static let heartsAnimation: [UIImage] = [#imageLiteral(resourceName: "heart.png"),#imageLiteral(resourceName: "twohearts.png")]
}

enum Movement {
    case movingLeft
    case movingRight
    case staying
}

enum Location {
    case middle
    case bowls
    case bed
    case toy
}
