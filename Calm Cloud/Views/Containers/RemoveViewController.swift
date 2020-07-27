//
//  RemoveViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/22/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class RemoveViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var message: UILabel!

    // MARK: Variables
    
    var remove = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadRemove), name: NSNotification.Name(rawValue: "loadRemove"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadWilted), name: NSNotification.Name(rawValue: "loadWilted"), object: nil)
    }
    
    @objc func loadRemove() {
        getName()
        
        message.text = "This plant, a \(remove), will be gone forever once removed. Proceed?"
    }
    
    @objc func loadWilted() {
        getName()
        
        message.text = "This plant, a wilted \(remove), will be gone forever once removed. Proceed?"
    }
    
    func getName() {
        let planting = Plantings.plantings.filter { $0.id == PlantManager.chosen }.first
        
        guard let plant = planting else { return }
        
        for seedling in Plantings.seedlings {
            if seedling.plant == Plant(rawValue: Int(plant.plant))! {
                remove = seedling.name
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
    
    @IBAction func yesTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePlant"), object: nil)
    }
    
    @IBAction func noTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeRemoveMessage"), object: nil)
    }
}
