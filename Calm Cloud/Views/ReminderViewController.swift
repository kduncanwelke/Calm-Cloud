//
//  ReminderViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

    // MARK: IBOutlets
  
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var dailySwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.minimumDate = Date()
    }
    
    func updateUI() {
        if dailySwitch.isOn {
            datePicker.isEnabled = false
            timePicker.minimumDate = nil
        } else {
            datePicker.isEnabled = true
            timePicker.minimumDate = Date()
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
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        updateUI()
    }
    

    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
