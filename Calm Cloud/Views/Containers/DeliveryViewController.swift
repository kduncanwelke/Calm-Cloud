//
//  DeliveryViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/21/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class DeliveryViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var seedlingMessage: UILabel!
    
    var selected: Plant?
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        randomSeeds()
    }
    
    func randomSeeds() {
        let random = Int.random(in: 0...9)
        let type = Plant(rawValue: random)
        selected = type
        
        // if geranium or lemon (single pot plants) only give one seedling
        if random == 3 || random == 5 || random == 6 {
            number = 1
        } else {
            number = Int.random(in: 1...3)
        }
        
        let name = getName()
        seedlingMessage.text = "x\(number) \(name) Seedlings"
        add()
    }
    
    func getName() -> String {
        switch selected {
        case .chard:
            return "Rainbow Chard"
        case .geranium:
            return "Pink Geranium"
        case .jade:
            return "Jade"
        case .lemon:
            return "Lemon Tree"
        case .pumpkin:
            return "Pumpkin"
        case .redTulip:
            return "Red Tulip"
        case .redGeranium:
            return "Red Geranium"
        case .yellowTulip:
            return "Yellow Tulip"
        default:
            return ""
        }
    }
    
    func add() {
        guard let chosen = selected else { return }
        
        if let plantCount = Plantings.availableSeedlings[chosen] {
            Plantings.availableSeedlings[chosen] = plantCount + number
        }
        
        DataFunctions.saveInventory()
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
    
    @IBAction func okPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeDelivery"), object: nil)
    }
}
