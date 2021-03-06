//
//  ReminderListViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ReminderListViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    
    let dateFormatter = DateFormatter()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        
        loadReminders()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = Colors.pink
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: Custom functions
    
    @objc func reloadTable() {
        tableView.reloadData()
    }
    
    func loadReminders() {
        // load saved reminders
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Reminder>(entityName: "Reminder")
        
        do {
            ReminderManager.remindersList = try managedContext.fetch(fetchRequest)
            print("reminders loaded")
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func fullDelete(reminder: Reminder) {
        // delete reminder, including notification
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = "\(reminder.id)"
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        managedContext.delete(reminder)
        
        do {
            try managedContext.save()
            print("delete successful")
        } catch {
            print("Failed to delete")
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
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addReminder", sender: Any?.self)
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
