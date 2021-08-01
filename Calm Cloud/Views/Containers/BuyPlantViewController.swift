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
    
    var costPer = 0
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadUI), name: NSNotification.Name(rawValue: "loadUI"), object: nil)
        insufficientFunds.isHidden = true
    }
    
    @objc func loadUI() {
        if let current = PlantManager.buying {
            costPer = current.price
            buyingLabel.text = current.name
            plantImage.image = current.image
            numberLabel.text = "0"
            totalCost.text = " 0"
            
            if let number = Plantings.availableSeedlings[current.plant] {
               howManyLabel.text = "How many?\n\(number) owned"
            } else {
               howManyLabel.text = "How many?\n0 owned"
            }
            
        } else if let current = ItemManager.buying {
            costPer = current.price
            buyingLabel.text = current.name
            plantImage.image = current.image
            numberLabel.text = "0"
            totalCost.text = " 0"
            
            switch current.type {
            case .wood:
                 howManyLabel.text = "+ \(current.hours) hour(s) of fireplace time \n (\(Fireplace.hours) hours left)"
            case .color:
                howManyLabel.text = "+ \(current.hours) hour(s) of colorful fire \n (\(Fireplace.colorHours) hours left)"
            }
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
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        number = Int(stepper.value)
        numberLabel.text = "\(number)"
        totalCost.text = " \(costPer * number)"
        
        if let current = ItemManager.buying {
            var hours = current.hours * number
            
            switch current.type {
            case .wood:
                howManyLabel.text = "+ \(hours) hour(s) of fireplace time \n (\(Fireplace.hours) hours left)"
            case .color:
                howManyLabel.text = "+ \(hours) hour(s) of colorful fire \n (\(Fireplace.colorHours) hours left)"
            }
        }
    }
    
    @IBAction func buyPressed(_ sender: UIButton) {
        if number == 0 {
            return
        }
        
        if costPer * number > MoneyManager.total {
            print("not enough funds!")
            insufficientFunds.isHidden = false
            insufficientFunds.animateBounce()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.insufficientFunds.isHidden = true
            }
        } else {
            if let current = PlantManager.buying {
            
                // update inventory
                if let oldCount = Plantings.availableSeedlings[current.plant] {
                    Plantings.availableSeedlings[current.plant] = oldCount + number
                    DataFunctions.saveInventory()
                }
                
                // deduct funds
                MoneyManager.total -= costPer * number
                DataFunctions.saveMoney()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissWithPurchase"), object: nil)
                
                // reset
                number = 0
                stepper.value = 0
                PlantManager.buying = nil
            } else if let current = ItemManager.buying {
                // update total time available
                let hours = current.hours * number
                
                switch current.type {
                case .wood:
                    DataFunctions.addFuel(hours: hours, type: .wood)
                case .color:
                    DataFunctions.addFuel(hours: hours, type: .color)
                }
               
                // deduct funds
                MoneyManager.total -= costPer * number
                DataFunctions.saveMoney()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissWithPurchase"), object: nil)
                
                // reset
                ItemManager.buying = nil
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        number = 0
        stepper.value = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissPurchase"), object: nil)
    }

}
