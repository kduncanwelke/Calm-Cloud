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

    private let miniGameViewModel = MiniGameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        coin.isHidden = true
        againButton.isHidden = true
        
        cloudKitty.animationImages = AnimationManager.revealAnimation
        cloudKitty.animationDuration = 0.4
        cloudKitty.animationRepeatCount = 1
    }
    
    
    func newRound() {
        miniGameViewModel.setForNewRound()
        
        coin.isHidden = true
        leftPot.image = UIImage(named: "gamepot")
        middlePot.image = UIImage(named: "gamepot")
        rightPot.image = UIImage(named: "gamepot")
        againButton.isHidden = true
    }
    
    func results() {
        if miniGameViewModel.addReward() {
            coin.isHidden = false
            coin.animateBounce()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
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
        if miniGameViewModel.isGameNotEnded() {
            miniGameViewModel.setSelected(number: 1)
            cloudKitty.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                var result = miniGameViewModel.getPotImage()

                leftPot.image = result.image
                if result.win {
                    results()
                }
                
                miniGameViewModel.endGame()
                self.againButton.isHidden = false
            }
        }
    }
    
    @IBAction func middlePotTapped(_ sender: UITapGestureRecognizer) {
        if miniGameViewModel.isGameNotEnded() {
            miniGameViewModel.setSelected(number: 2)
            cloudKitty.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                var result = miniGameViewModel.getPotImage()

                middlePot.image = result.image
                if result.win {
                    results()
                }

                miniGameViewModel.endGame()
                self.againButton.isHidden = false
            }
        }
    }
    
    @IBAction func rightPotTapped(_ sender: UITapGestureRecognizer) {
        if miniGameViewModel.isGameNotEnded() {
            miniGameViewModel.setSelected(number: 3)
            cloudKitty.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                var result = miniGameViewModel.getPotImage()

                rightPot.image = result.image
                if result.win {
                    results()
                }

                miniGameViewModel.endGame()
                self.againButton.isHidden = false
            }
        }
    }
    
    @IBAction func againPressed(_ sender: UIButton) {
        newRound()
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideMiniGame"), object: nil)
    }
}
