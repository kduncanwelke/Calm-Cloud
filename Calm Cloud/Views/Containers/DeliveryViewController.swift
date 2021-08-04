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

    // MARK: Variables

    private let deliveryViewModel = DeliveryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadDelivery), name: NSNotification.Name(rawValue: "loadDelivery"), object: nil)
    }
    
    @objc func loadDelivery() {
        seedlingMessage.text = deliveryViewModel.randomSeeds()
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
