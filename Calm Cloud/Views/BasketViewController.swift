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
        reset()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
