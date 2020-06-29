//
//  PlantManager+Images.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/29/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension PlantManager {
    // extension to hold images (since there are many)
    
    // MARK: Tulips
    
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
    
    static var yellowTulip: UIImage {
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
                    return #imageLiteral(resourceName: "yellowtulip6.png")
                } else {
                    return #imageLiteral(resourceName: "yellowtulip6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "yellowtulip7.png")
                } else {
                    return #imageLiteral(resourceName: "yellowtulip7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "redtulip8.png")
            }
        }
    }
    
    static var pinkTulip: UIImage {
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
                    return #imageLiteral(resourceName: "pinktulip6.png")
                } else {
                    return #imageLiteral(resourceName: "pinktulip6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "pinktulip7.png")
                } else {
                    return #imageLiteral(resourceName: "pinktulip7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "redtulip8.png")
            }
        }
    }
    
    static var whiteTulip: UIImage {
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
                    return #imageLiteral(resourceName: "whitetulip6.png")
                } else {
                    return #imageLiteral(resourceName: "whitetulip6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "whitetulip7.png")
                } else {
                    return #imageLiteral(resourceName: "whitetulip7water.png")
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
    
    // MARK: Bell Pepper
    
    static var pepper: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper1.png")
                } else {
                    return #imageLiteral(resourceName: "pepper1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper2.png")
                } else {
                    return #imageLiteral(resourceName: "pepper2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper3.png")
                } else {
                    return #imageLiteral(resourceName: "pepper3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper4.png")
                } else {
                    return #imageLiteral(resourceName: "pepper4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper5.png")
                } else {
                    return #imageLiteral(resourceName: "pepper5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper6.png")
                } else {
                    return #imageLiteral(resourceName: "pepper6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "pepper7.png")
                } else {
                    return #imageLiteral(resourceName: "pepper7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "pepper8.png")
            }
        }
    }
    
    // MARK: Grape Tomato
    
    static var tomato: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato1.png")
                } else {
                    return #imageLiteral(resourceName: "tomato1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato2.png")
                } else {
                    return #imageLiteral(resourceName: "tomato2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato3.png")
                } else {
                    return #imageLiteral(resourceName: "tomato3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato4.png")
                } else {
                    return #imageLiteral(resourceName: "tomato4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato5.png")
                } else {
                    return #imageLiteral(resourceName: "tomato5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato6.png")
                } else {
                    return #imageLiteral(resourceName: "tomato6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "tomato7.png")
                } else {
                    return #imageLiteral(resourceName: "tomato7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "tomato8.png")
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
    
    // MARK: Lime
    
    static var lime: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplottree.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "lime1.png")
                } else {
                    return #imageLiteral(resourceName: "lime1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "lime2.png")
                } else {
                    return #imageLiteral(resourceName: "lime2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "lime3.png")
                } else {
                    return #imageLiteral(resourceName: "lime3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "lime4.png")
                } else {
                    return #imageLiteral(resourceName: "lime4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "lime5.png")
                } else {
                    return #imageLiteral(resourceName: "lime5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "lime6.png")
                } else {
                    return #imageLiteral(resourceName: "lime6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "lime7.png")
                } else {
                    return #imageLiteral(resourceName: "lime7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "lime8.png")
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
    
    // MARK: Yellow Squash
    
    static var squash: UIImage {
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
                    return #imageLiteral(resourceName: "squash5.png")
                } else {
                    return #imageLiteral(resourceName: "squash5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "squash6.png")
                } else {
                    return #imageLiteral(resourceName: "squash6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "squash7.png")
                } else {
                    return #imageLiteral(resourceName: "squash7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "pumpkin8.png")
            }
        }
    }
    
    // MARK: Strawberry
    
    static var strawberry: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplotbig.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry1.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry2.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry3.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry4.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry5.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry6.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "strawberry7.png")
                } else {
                    return #imageLiteral(resourceName: "strawberry7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "strawberry8.png")
            }
        }
    }
    
    // MARK: Watermelon
    
    static var watermelon: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplotbig.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon1.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon2.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon3.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon4.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon5.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon6.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "watermelon7.png")
                } else {
                    return #imageLiteral(resourceName: "watermelon7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "watermelon8.png")
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
    
    static var redGeranium: UIImage {
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
                    return #imageLiteral(resourceName: "redgeranium.png")
                } else {
                    return #imageLiteral(resourceName: "redgeraniumwater.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "geranium8.png")
            }
        }
    }
    
    static var carrot: UIImage {
        get {
            switch PlantManager.currentStage {
            case .zero:
                return #imageLiteral(resourceName: "emptyplot.png")
            case .one:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot1.png")
                } else {
                    return #imageLiteral(resourceName: "carrot1water.png")
                }
            case .two:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot2.png")
                } else {
                    return #imageLiteral(resourceName: "carrot2water.png")
                }
            case .three:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot3.png")
                } else {
                    return #imageLiteral(resourceName: "carrot3water.png")
                }
            case .four:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot4.png")
                } else {
                    return #imageLiteral(resourceName: "carrot4water.png")
                }
            case .five:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot5.png")
                } else {
                    return #imageLiteral(resourceName: "carrot5water.png")
                }
            case .six:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot6.png")
                } else {
                    return #imageLiteral(resourceName: "carrot6water.png")
                }
            case .seven:
                if needsWater {
                    return #imageLiteral(resourceName: "carrot7.png")
                } else {
                    return #imageLiteral(resourceName: "carrot7water.png")
                }
            case .eight:
                return #imageLiteral(resourceName: "carrot8.png")
            }
        }
    }
}
