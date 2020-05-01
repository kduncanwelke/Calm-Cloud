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
    
    func moveLeftToPlanter() {
        print("left to planter")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let planterDestination = CGPoint(x: container.frame.width/8, y: (container.frame.height/3)*2)
        cloudKitty.outsideMove(to: planterDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
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
        moveLeftToPlanter()
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
        self.dismiss(animated: true, completion: nil)
    }
    
}
