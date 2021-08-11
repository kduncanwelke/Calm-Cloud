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

    private let basketViewModel = BasketViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        basketViewModel.performDataLoads()
        
        addedImage.alpha = 0.0
        donatedView.alpha = 0.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = Colors.pink

        toggleButtons()

        basketViewModel.loadItems()
        tableView.reloadData()
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
    
    func toggleButtons() {
        if segmentedControl.selectedSegmentIndex == -1 {
            doneButton.isEnabled = false
            cancelButton.isEnabled = false
        } else if segmentedControl.selectedSegmentIndex == 0 {
            doneButton.isEnabled = basketViewModel.enableDoneButtonStand()
            cancelButton.isEnabled = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            doneButton.isEnabled = basketViewModel.enableDoneButtonDonation()
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
        var result = basketViewModel.saveChanges(segment: segmentedControl.selectedSegmentIndex)

        if result.honorStand {
            addedImage.animateFadeInSlow()
        } else if result.donated {
            expLabel.text = "+\(basketViewModel.randomEXP())EXP"
            donatedView.animateFadeInSlow()
        }
        
        // send notification here so if user both donates and puts in the honor stand
        // the honor stand will still update
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadHonorStand"), object: nil)
        
        reset()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource, QuantityChangeDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketViewModel.getItemTotal()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketTableViewCell

        if segmentedControl.selectedSegmentIndex == -1 {
            cell.stepper.isHidden = true
            cell.selectedNumber.isHidden = true
            cell.quantityLabel.isHidden = false
        } else {
            cell.stepper.isHidden = false
            cell.selectedNumber.isHidden = false
            cell.quantityLabel.isHidden = true
        }

        cell.itemLabel.text = basketViewModel.getName(index: indexPath.row)
        cell.selectedNumber.text = "0"
        cell.stepper.value = 0

        cell.quantityLabel.text = "\(basketViewModel.getQuantity(index: indexPath.row))"
        cell.stepper.maximumValue = Double(basketViewModel.getQuantity(index: indexPath.row))
        cell.stepper.minimumValue = 0

        cell.cellDelegate = self

        return cell
    }

    func didChangeQuantity(sender: BasketTableViewCell, number: Int, direction: Direction) {
        let path = self.tableView.indexPath(for: sender)
        if let selected = path {

            basketViewModel.adjustCounts(index: selected.row, segment: segmentedControl.selectedSegmentIndex, direction: direction, number: number)
            
            // toggle buttons based on selection, not active if no items are selected
            toggleButtons()
            print("quantity delegate called")
        }
    }

}

