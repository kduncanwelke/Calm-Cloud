//
//  TasksViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/12/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var journalComplete: UIImageView!
    @IBOutlet weak var photoComplete: UIImageView!
    @IBOutlet weak var activitiesComplete: UIImageView!
    @IBOutlet weak var allComplete: UILabel!
    @IBOutlet weak var getReward: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTasks), name: NSNotification.Name(rawValue: "reloadTasks"), object: nil)
        toggleChecks()
    }
    
    @objc func reloadTasks() {
        toggleChecks()
    }
    
    func toggleChecks() {
        if TasksManager.activities {
            activitiesComplete.image = UIImage(named: "correct")
        } else {
            activitiesComplete.image = UIImage(named: "unchecked")
        }
        
        if TasksManager.journal {
            journalComplete.image = UIImage(named: "correct")
        } else {
            journalComplete.image = UIImage(named: "unchecked")
        }
        
        if TasksManager.photo {
            photoComplete.image = UIImage(named: "correct")
        } else {
            photoComplete.image = UIImage(named: "unchecked")
        }
        
        if TasksManager.activities && TasksManager.journal && TasksManager.photo && TasksManager.rewardCollected == false {
            allComplete.isHidden = false
            getReward.isHidden = false
        } else {
            allComplete.isHidden = true
            getReward.isHidden = true
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
    
    @IBAction func rewardPressed(_ sender: UIButton) {
        // add coin reward
        MoneyManager.total += Int.random(in: 10...15)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
        getReward.isHidden = true
        TasksManager.rewardCollected = true
        DataFunctions.saveTasks()
    }
    

    @IBAction func closePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeTasks"), object: nil)
    }
}
