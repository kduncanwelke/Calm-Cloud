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
    
    func goToSleep(to destination: CGPoint, duration: TimeInterval,
              options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: {(finished: Bool) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToSleep"), object: nil)
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
    
    func outsideMove(to destination: CGPoint, duration: TimeInterval,
              options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: {(finished: Bool) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMovingOutside"), object: nil)
        })
    }
    
    func floatMoveOutside(to destination: CGPoint, returnTo: CGPoint, duration: TimeInterval,
                   options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: {(finished: Bool) in
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.center = returnTo
            }, completion: {(finished: Bool) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMovingOutside"), object: nil)
            })
        })
    }
    
    func animateImageRight() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(translationX: -150.0, y: 0.0)
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { [unowned self] _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform.identity
                }
            })
        })
    }
    
    func animateImageLeft() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(translationX: 150.0, y: 0.0)
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { [unowned self] _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform.identity
                }
            })
        })
    }
    
    func animateFadeIn() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0.0
            }
        })
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 2.0, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 2.0, animations: {
            self.alpha = 0.0
        })
    }
    
}
