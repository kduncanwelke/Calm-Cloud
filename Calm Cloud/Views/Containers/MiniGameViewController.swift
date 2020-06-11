//
//  MiniGameViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/7/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class MiniGameViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var cloudKitty: UIImageView!
    @IBOutlet weak var firstNumber: UILabel!
    @IBOutlet weak var unknownNumber: UILabel!
    @IBOutlet weak var higherButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var lowerButton: UIButton!
    @IBOutlet weak var feedback: UIImageView!
    @IBOutlet weak var coin: UIImageView!

    
    // MARK: Variables
    
    var previousNumber = 6
    var revealedNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        againButton.isHidden = true
        feedback.isHidden = true
        coin.isHidden = true
        
        previousNumber = Int.random(in: 1...10)
        firstNumber.text = "\(previousNumber)"
        
        cloudKitty.animationImages = AnimationManager.revealAnimation
        cloudKitty.animationDuration = 0.4
        cloudKitty.animationRepeatCount = 1
    }
    
    func newNumber() {
        let number = Int.random(in: 1...10)
        previousNumber = number
        firstNumber.text = "\(number)"
        firstNumber.animateBounce()
        unknownNumber.text = "?"
        unknownNumber.animateBounce()
    }
    
    func randomNumber() -> String {
        let number = Int.random(in: 1...10)
        revealedNumber = number
        return "\(number)"
    }
    
    func newRound() {
        higherButton.isHidden = true
        lowerButton.isHidden = true
        againButton.isHidden = false
        againButton.fadeIn()
    }
    
    func randomCoinReward() -> Int? {
        if Bool.random() {
            return Int.random(in: 1...5)
        } else {
            return nil
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
    
    @IBAction func higherPressed(_ sender: UIButton) {
        cloudKitty.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.unknownNumber.text = self.randomNumber()
            
            if self.revealedNumber >= self.previousNumber {
                self.feedback.isHidden = false
                self.feedback.animateBounce()
                self.feedback.image = UIImage(named: "correct")
            } else {
                self.feedback.isHidden = false
                self.feedback.animateBounce()
                self.feedback.image = UIImage(named: "incorrect")
            }
            
            self.newRound()
        }
       
    }
    
    @IBAction func againPressed(_ sender: UIButton) {
        newNumber()
        higherButton.isHidden = false
        higherButton.animateBounce()
        lowerButton.isHidden = false
        lowerButton.animateBounce()
        againButton.isHidden = true
        feedback.isHidden = true
        coin.isHidden = true
    }
    
    @IBAction func lowerPressed(_ sender: UIButton) {
        cloudKitty.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.unknownNumber.text = self.randomNumber()
            
            if self.revealedNumber <= self.previousNumber {
                self.feedback.isHidden = false
                self.feedback.animateBounce()
                self.feedback.image = UIImage(named: "correct")
                
                if let reward = self.randomCoinReward() {
                    MoneyManager.total += reward
                    self.coin.isHidden = false
                    self.coin.animateBounce()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
                }
            } else {
                self.feedback.isHidden = false
                self.feedback.animateBounce()
                self.feedback.image = UIImage(named: "incorrect")
            }
            
            self.newRound()
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeMiniGame"), object: nil)
    }
}
