//
//  AnimationExtensions.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func move(to destination: CGPoint, duration: TimeInterval,
              options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: {(finished: Bool) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        })
    }
    
    func floatMove(to destination: CGPoint, returnTo: CGPoint, duration: TimeInterval,
                   options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: {(finished: Bool) in
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.center = returnTo
            }, completion: {(finished: Bool) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
            })
        })
    }
}
