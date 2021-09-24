//
//  CloudsTimer.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 9/24/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

class CloudsTimer {
    static var seconds = 900
    static var timer: Timer?

    // timer for animations
    static func beginTimer(label: UILabel) {
        let calendar = Calendar.current

        // unless timer is being run right away, time left to the next cloud may be under 15 minutes
        if let lastDate = PlaysModel.lastUsed {
            let timeToSubtract = calendar.dateComponents([.second], from: lastDate, to: Date())

            seconds = 900 - (timeToSubtract.second ?? 0)
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds -= 1

            if seconds <= 0 {
                stop()
            } else if seconds < 60 {
                if seconds < 10 {
                    label.text = "0:0\(seconds) to next cloud"
                } else {
                    label.text = "0:\(Int(seconds)) to next cloud"
                }
            } else if seconds >= 3600 {
                let minute = Int(seconds / 60)
                let second = seconds % 60

                if minute < 10 {
                    if second < 10 {
                        label.text = "\(minute):0\(second) to next cloud"
                        print("sec")
                    } else {
                        label.text = "\(minute):\(second) to next cloud"
                        print("minute")
                    }
                }

                if minute > 10 && second < 10 {
                    label.text = "\(minute):0\(second) to next cloud"
                } else if minute > 10 && second > 10 {
                    label.text = "\(minute):\(second) to next cloud"
                }
            } else {
                let minute = seconds / 60
                let second = seconds % 60
                if second < 10 {
                    label.text = "\(minute):0\(second) to next cloud"
                } else {
                    label.text = "\(minute):\(second) to next cloud"
                }
            }
        }

        timer?.fire()
    }

    static func stop() {
        timer?.invalidate()
        seconds = 900

        if PlaysModel.clouds != 5 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addCloud"), object: nil)
        }
    }
}
