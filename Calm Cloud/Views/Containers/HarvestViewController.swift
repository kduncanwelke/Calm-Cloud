//
//  HarvestViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class HarvestViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        load()
    }
    
    @objc func load() {
        let planting = Plantings.plantings.filter { $0.id == Int16(PlantManager.chosen) }.first
        let days = PlantManager.checkDiff(date: planting?.mature)
        message.text = "This plant has \(days) day(s) of maturity left before it wilts. Would you like to harvest it now?"
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
    
    @IBAction func harvestPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "harvestPlant"), object: nil)
    }
    
    @IBAction func noPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeHarvestMessage"), object: nil)
    }

}
