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
        guard let current = PlantManager.buying else { return }
        costPer = current.price
        buyingLabel.text = current.name
        plantImage.image = current.image
        numberLabel.text = "0"
        totalCost.text = " 0"
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
    }
    
    @IBAction func buyPressed(_ sender: UIButton) {
        if costPer * number > MoneyManager.total {
            print("not enough funds!")
            insufficientFunds.isHidden = false
            insufficientFunds.animateBounce()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self.insufficientFunds.isHidden = true
            }
        } else {
            guard let current = PlantManager.buying else { return }
            
            // update inventory
            if let oldCount = Plantings.availableSeedlings[current.plant] {
                Plantings.availableSeedlings[current.plant] = oldCount + number
                DataFunctions.saveInventory()
            }
            
            // deduct funds
            MoneyManager.total -= costPer * number
            DataFunctions.saveMoney()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissWithPurchase"), object: nil)
            // ring sound?
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissPurchase"), object: nil)
    }

}
