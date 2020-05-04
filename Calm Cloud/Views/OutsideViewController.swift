//
//  OutsideViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class OutsideViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cloudKitty: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         NotificationCenter.default.addObserver(self, selector: #selector(stopMovingOutside), name: NSNotification.Name(rawValue: "stopMovingOutside"), object: nil)
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        sleep()
    }
    
    // MARK: Custom functions
    
    func randomRepeatCount() -> Int {
        var randomRepeatCount = Int.random(in: 4...8)
        return randomRepeatCount
    }
    
    func floatUp() {
        print("float")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    // left movement
    
    func floatLeft() {
        print("float left")
        cloudKitty.animationImages = AnimationManager.upsideDownLeft
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToPlanter() {
        print("left to planter")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let planterDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2)
        cloudKitty.outsideMove(to: planterDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToWidePot() {
        print("left to wide pot")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let potDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveLeftToCenter() {
        print("left to center")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    // right movement
    
    func floatRight() {
        print("float right")
        cloudKitty.animationImages = AnimationManager.upsideDownRight
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/1.12, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToBack() {
        print("right to back")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    func moveRightToGate() {
        print("right to gate")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let gateDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*1.5)
        cloudKitty.outsideMove(to: gateDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
    }
    
    // in-place movements
    
    func sleep() {
        print("sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    @objc func stopMovingOutside() {
        cloudKitty.stopAnimating()
        let range = [1,2]
        let animation = range.randomElement()
        cloudKitty.stopAnimating()
        
        if animation == 1 {
            floatUp()
            
        } else {
            sleep()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: IBActions
    
    @IBAction func returnPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        cloudKitty.stopAnimating()
        AnimationTimer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
}
