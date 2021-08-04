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
    @IBOutlet weak var rewardDetails: UIStackView!

    // MARK: Variables

    private let tasksViewModel = TasksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTasks), name: NSNotification.Name(rawValue: "reloadTasks"), object: nil)
        rewardDetails.alpha = 0
        toggleChecks()
    }
    
    @objc func reloadTasks() {
        toggleChecks()
    }
    
    func toggleChecks() {
        activitiesComplete.image = tasksViewModel.activitiesCheck()
        journalComplete.image = tasksViewModel.journalCheck()
        photoComplete.image = tasksViewModel.photoCheck()

        print(TasksManager.rewardCollected)

        var status = tasksViewModel.toggleButtons()
        allComplete.isHidden = status.hideComplete
        getReward.isHidden = status.hideReward
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
    
    @IBAction func rewardPressed(_ sender: UIButton) {
        // add coin and exp reward
        allComplete.isHidden = true
        getReward.isHidden = true

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateExperience"), object: nil)

        rewardDetails.animateFadeInSlow()
        tasksViewModel.collectReward()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "viewInfo", sender: Any?.self)
    }

    @IBAction func closePressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeTasks"), object: nil)
    }
}
