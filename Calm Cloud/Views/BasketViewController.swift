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
    
    // MARK: Variables
    
    var itemsToShow: [BasketItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DataFunctions.loadHarvest()
        
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
        } else {
            doneButton.isEnabled = true
            cancelButton.isEnabled = true
        }
    }
    
    func reset() {
        segmentedControl.selectedSegmentIndex = -1
        tableView.reloadData()
        toggleButtons()
    }
    
    func saveHonorStandItems() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save anew if it doesn't exist (like on app initial launch)
        if Harvested.stand.isEmpty {
            for (type, quantity) in Harvested.inStand {
                
                let standSave = HonorStandItem(context: managedContext)
                
                standSave.id = Int16(type.rawValue)
                standSave.quantity = Int16(quantity)
                
                Harvested.stand.append(standSave)
                
                // update quantity in basket
                if let oldCount = Harvested.basketCounts[type] {
                    let newCount = oldCount - quantity
                    
                    Harvested.basketCounts[type] = newCount
                }
                
                do {
                    try managedContext.save()
                    print("saved honor stand item")
                } catch {
                    // this should never be displayed but is here to cover the possibility
                    print("failed to save honor stand")
                }
            }
            
            DataFunctions.saveHarvest()
            
            return
        }
        
        // otherwise rewrite data
        var resave: [HonorStandItem] = []
        
        for item in Harvested.stand {
            let quantity = Harvested.inStand[Plant(rawValue: Int(item.id))!]
            item.quantity = Int16(quantity!)
            
            resave.append(item)
            
            // update quantity in basket
            if let oldCount = Harvested.basketCounts[Plant(rawValue: Int(item.id))!], let number = quantity {
                let newCount = oldCount - number
                
                Harvested.basketCounts[Plant(rawValue: Int(item.id))!] = newCount
            }
        
            do {
                try managedContext.save()
                print("resave successful")
            } catch {
                // this should never be displayed but is here to cover the possibility
                print("failed to save honor stand")
            }
        }
        
        Harvested.stand.removeAll()
        Harvested.stand = resave
        
        DataFunctions.saveHarvest()
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
        saveHonorStandItems()
        reset()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
