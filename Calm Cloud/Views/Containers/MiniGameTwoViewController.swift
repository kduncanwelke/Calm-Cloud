//
//  MiniGameTwoViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/23/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class MiniGameTwoViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var coin: UIImageView!
    @IBOutlet weak var leftPot: UIImageView!
    @IBOutlet weak var middlePot: UIImageView!
    @IBOutlet weak var rightPot: UIImageView!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var cloudKitty: UIImageView!
    
    // MARK: Variables
    
    var correctPot = 0
    var selection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        coin.isHidden = true
        againButton.isHidden = true
        
        cloudKitty.animationImages = AnimationManager.revealAnimation
        cloudKitty.animationDuration = 0.4
        cloudKitty.animationRepeatCount = 1
    }
    
    func randomNumber() {
        let number = Int.random(in: 1...3)
        correctPot = number
    }
    
    func newRound() {
        coin.isHidden = true
        leftPot.image = UIImage(named: "gamepot")
        middlePot.image = UIImage(named: "gamepot")
        rightPot.image = UIImage(named: "gamepot")
        randomNumber()
        againButton.isHidden = true
    }
    
    func randomCoinReward() -> Int? {
        let chance = Int.random(in: 1...10)
        
        // 1 in 10 chance of getting reward
        if chance == 7 {
            return Int.random(in: 1...5)
        } else {
            return nil
        }
    }
    
    func results() {
        if let reward = randomCoinReward() {
            MoneyManager.total += reward
            coin.isHidden = false
            coin.animateBounce()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
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
    
    @IBAction func leftPotTapped(_ sender: UITapGestureRecognizer) {
        selection = 1
        cloudKitty.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            if self.selection == self.correctPot {
                self.leftPot.image = UIImage(named: "snailpot")
                self.results()
            } else {
                self.leftPot.image = UIImage(named: "potnosnail")
            }
            
            self.againButton.isHidden = false
        }
    }
    
    @IBAction func middlePotTapped(_ sender: UITapGestureRecognizer) {
        selection = 2
        cloudKitty.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            if self.selection == self.correctPot {
                self.middlePot.image = UIImage(named: "snailpot")
                self.results()
            } else {
                self.middlePot.image = UIImage(named: "potnosnail")
            }
            
            self.againButton.isHidden = false
        }
    }
    
    @IBAction func rightPotTapped(_ sender: UITapGestureRecognizer) {
        selection = 3
        cloudKitty.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            if self.selection == self.correctPot {
                self.rightPot.image = UIImage(named: "snailpot")
                self.results()
            } else {
                self.rightPot.image = UIImage(named: "potnosnail")
            }
            
            self.againButton.isHidden = false
        }
    }
    
    @IBAction func againPressed(_ sender: UIButton) {
        newRound()
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMiniGame"), object: nil)
    }

}
