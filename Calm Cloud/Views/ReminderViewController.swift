//
//  ReminderViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ReminderViewController: UIViewController {

    // MARK: IBOutlets
  
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var dailySwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var savedImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        savedImage.alpha = 0.0
        datePicker.minimumDate = Date()
        saveButton.isEnabled = false

        messageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: Variables

    private let reminderViewModel = ReminderViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check if notifications are enabled, as this is the first point of use
        UNUserNotificationCenter.current().getNotificationSettings(){ [unowned self] (settings) in
            switch settings.alertSetting {
            case .enabled:
                break
            case .disabled:
                DispatchQueue.main.async {
                    self.showSettingsAlert(title: "Notifications disabled", message: "Time-based reminders require access to notification sevices to provide notifications of exhibits. These notifications will not be displayed unless settings are adjusted.")
                }
            case .notSupported:
                DispatchQueue.main.async {
                    self.showSettingsAlert(title: "Notifications not supported", message: "Notifications will not be displayed, as the service is not available on this device.")
                }
            @unknown default:
                return
            }
        }
    }

    // MARK: Custom functions
    
    func updateUI() {
        if dailySwitch.isOn {
            datePicker.isEnabled = false
            timePicker.minimumDate = nil
        } else {
            datePicker.isEnabled = true
            timePicker.minimumDate = Date()
        }
    }
    
    func resetUI() {
        dailySwitch.isOn = false
        datePicker.date = Date()
        timePicker.date = Date()
        messageTextField.text = ""
        saveButton.isEnabled = false
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
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

    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        // if text view is active and user taps off of it, dismiss
        if messageTextField.isFirstResponder {
            messageTextField.resignFirstResponder()
        }
    }

    @IBAction func switchPressed(_ sender: UISwitch) {
        updateUI()
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        if messageTextField.isFirstResponder {
            messageTextField.resignFirstResponder()
        }

        resetUI()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        reminderViewModel.saveReminder(message: messageTextField, datePicker: datePicker, switchOn: dailySwitch.isOn)
        savedImage.animateFadeInSlow()
        resetUI()
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
