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
        NotificationCenter.default.addObserver(self, selector: #selector(load), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        load()
    }
    
    @objc func load() {
        let planting = Plantings.plantings.filter { $0.id == PlantManager.chosen }.first
        
        guard let plant = planting else { return }
        
        var name = ""
        
        for seedling in Plantings.seedlings {
            if seedling.plant == Plant(rawValue: Int(plant.plant))! {
                PlantManager.selected = seedling.plant
                name = seedling.name
            }
        }
        
        let daysLeft = PlantManager.checkDiff(date: plant.mature)
        print(daysLeft)
        var days = 5 - daysLeft
       
        message.text = "This plant, a \(name), is mature and will wilt in \(days) day(s). Harvest it now?"
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
