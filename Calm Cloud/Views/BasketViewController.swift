//
//  BasketViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/4/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var donatedView: UIView!
    @IBOutlet weak var expLabel: UILabel!
    
    // MARK: Variables
    
    var itemsToShow: [BasketItem] = []
    var numberDonated = 0
    var numberSentToStand = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DataFunctions.loadHarvest()
        
        addedImage.alpha = 0.0
        donatedView.alpha = 0.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = Colors.pink
        
        loadItems()
        toggleButtons()
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
    
    func loadItems() {
        for (plant, number) in Harvested.basketCounts {
            if number != 0 {
                for item in Harvested.basketItems {
                    if item.plant == plant {
                        itemsToShow.append(item)
                        break
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func toggleButtons() {
        if segmentedControl.selectedSegmentIndex == -1 {
            doneButton.isEnabled = false
            cancelButton.isEnabled = false
        } else if segmentedControl.selectedSegmentIndex == 0 {
            if numberSentToStand != 0 {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
            
            cancelButton.isEnabled = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if numberDonated != 0 {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
            
            cancelButton.isEnabled = true
        }
    }
    
    func reset() {
        segmentedControl.selectedSegmentIndex = -1
        tableView.reloadData()
        toggleButtons()
    }
    
    func randomEXP() -> Int {
        var exp = 0
        
        for _ in 1...numberDonated {
            let randomEXP = Int.random(in: 5...15)
            exp += randomEXP
        }
        
        LevelManager.currentEXP += exp
        
        // update exp amounts where displayed, in home view and outside view
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromBasket"), object: nil)
        
        DataFunctions.saveLevel()
        
        return exp
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
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
        toggleButtons()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if numberSentToStand != 0 {
                DataFunctions.saveHonorStandItems()
                addedImage.animateFadeInSlow()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadHonorStand"), object: nil)
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if numberDonated != 0 {
                DataFunctions.saveHarvest()
                expLabel.text = "+\(randomEXP())EXP"
                donatedView.animateFadeInSlow()
                numberDonated = 0
            }
        }
        
        reset()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
