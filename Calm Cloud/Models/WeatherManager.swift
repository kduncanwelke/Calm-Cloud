//
//  WeatherManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 10/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct WeatherManager {
    
    static var currentWeather: Weather = .clearWarm
    static let range = [1,2,3]
    static let snowDays = [1, 3, 5, 7, 10, 11, 13, 15, 17, 19, 20, 23, 25, 29, 30, 31]
    
    static func hasSnow(month: Int, day: Int) -> Bool {
        // snow possible november through march
        if month < 4 || month >= 11 {
            if snowDays.contains(day) {
                return true
            } else {
                return false
            }
        } else {
            // month does not fall into snow range
            return false
        }
    }
    
    static func getWeather(month: Int, day: Int) -> Weather {
        let isRaining = range.randomElement()
        print("month: \(month)")
        // snow possible november through march
        if month < 4 || month >= 11 {
            if hasSnow(month: month, day: day) {
                let isSnowing = Bool.random()
                if isSnowing {
                    currentWeather = .snowing
                    return .snowing
                } else {
                    currentWeather = .snowOnGround
                    return .snowOnGround
                }
            } else {
                currentWeather = .clearCool
                return .clearCool
            }
        } else if month > 3 && month < 9 {
            // possible rainy months in summer
            if isRaining == 3 {
                currentWeather = .rainingWarm
                return .rainingWarm
            } else {
                currentWeather = .clearWarm
                return .clearWarm
            }
        } else {
            // possible rainy months in fall, sept-oct
            if isRaining == 3 {
                currentWeather = .rainingCool
                return .rainingCool
            } else {
                currentWeather = .clearCool
                return .clearCool
            }
        }
    }
    
    static let rainImages = [#imageLiteral(resourceName: "rain1.png"),#imageLiteral(resourceName: "rain2.png")]
    static let snowImages = [#imageLiteral(resourceName: "snow1.png"),#imageLiteral(resourceName: "snow2.png"),#imageLiteral(resourceName: "snow3.png"),#imageLiteral(resourceName: "snow4.png"),#imageLiteral(resourceName: "snow5.png"),#imageLiteral(resourceName: "snow6.png")]
}

enum Weather {
    case clearWarm
    case clearCool
    case rainingWarm
    case rainingCool
    case snowing
    case snowOnGround
}

enum WeatherCondition {
    case rain
    case snow
    case nothing
}
