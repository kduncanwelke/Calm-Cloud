//
//  BuyPlantViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class BuyPlantViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var buyingLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var insufficientFunds: UIView!
    @IBOutlet weak var howManyLabel: UILabel!
    
    // MARK: Variables

    private let plantPurchaseViewModel = PlantPurchaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadUI), name: NSNotification.Name(rawValue: "loadUI"), object: nil)
        insufficientFunds.isHidden = true
    }
    
    @objc func loadUI() {
        plantPurchaseViewModel.getPrice()
        buyingLabel.text = plantPurchaseViewModel.getName()
        plantImage.image = plantPurchaseViewModel.getImage()
        numberLabel.text = "0"
        totalCost.text = " 0"
        howManyLabel.text = plantPurchaseViewModel.getHowMany()
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
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        plantPurchaseViewModel.updateNumber(with: Int(stepper.value))
        
        numberLabel.text = plantPurchaseViewModel.getNumber()
        totalCost.text = plantPurchaseViewModel.getTotal()
        
        if let update = plantPurchaseViewModel.updateHowManyLabel() {
            howManyLabel.text = update
        }
    }
    
    @IBAction func buyPressed(_ sender: UIButton) {
        if plantPurchaseViewModel.zeroSelected() {
            return
        }
        
        if !plantPurchaseViewModel.sufficientFunds() {
            print("not enough funds!")
            insufficientFunds.isHidden = false
            insufficientFunds.animateBounce()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.insufficientFunds.isHidden = true
            }
        } else {
            plantPurchaseViewModel.purchase()

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissWithPurchase"), object: nil)

            // reset
            plantPurchaseViewModel.reset()
            stepper.value = 0
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        plantPurchaseViewModel.reset()
        stepper.value = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissPurchase"), object: nil)
    }
}
