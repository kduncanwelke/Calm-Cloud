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
    
    // MARK: Variables
    
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        savedImage.alpha = 0.0
        datePicker.minimumDate = Date()
    }
    
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
    }
    
    func getTime(reminder: Reminder) {
        // get time from picker
        let date = timePicker.date
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        guard let hour = components.hour, let minute = components.minute else { return }
        
        reminder.hour = Int64(hour)
        reminder.minute = Int64(minute)
    }
    
    func saveReminder() {
        // save reminder
        if messageTextField.text != "" {
            var managedContext = CoreDataManager.shared.managedObjectContext
            let newReminder = Reminder(context: managedContext)
            
            newReminder.name = messageTextField.text
            newReminder.id = Date()
            getTime(reminder: newReminder)
            
            if dailySwitch.isOn {
                newReminder.date = nil
            } else {
                newReminder.date = datePicker.date
            }
            
            ReminderManager.remindersList.append(newReminder)
            NotificationManager.addNotification(for: newReminder)
            
            do {
                try managedContext.save()
                print("saved reminder")
                savedImage.animateFadeIn()
                resetUI()
            } catch {
                // this should never be displayed but is here to cover the possibility
                showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
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
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        saveReminder()
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
