//
//  PopUpViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 5/8/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func goToInventory(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showInventory"), object: nil)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closePopUp"), object: nil)
    }
    
}
