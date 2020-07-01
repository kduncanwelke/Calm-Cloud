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
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var buyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadUI() {
        
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
    }
    
    @IBAction func buyPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissPurchase"), object: nil)
    }

}
