//
//  ActivitiesViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ActivitiesViewController: UIViewController, UISearchBarDelegate {

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tooSoonView: UIView!
    @IBOutlet weak var minutesLeft: UILabel!
    
    // MARK: Variables

    private let activitiesViewModel = ActivitiesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(showTooSoon), name: NSNotification.Name(rawValue: "showTooSoon"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.backgroundColor = UIColor.white
        tooSoonView.isHidden = true
        activitiesViewModel.loadCompleted()
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    @objc func showTooSoon() {
        tooSoonView.isHidden = false
        tooSoonView.animateBounce()
        minutesLeft.text = "\(Recentness.timeLeft) minutes left"
    }
    
    // MARK: Search bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch(searchText)
        
        if isFilteringBySearch() == false && searchBarIsEmpty() {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("dismiss")
    }
    
    // return search results based on title and entry body text
    func filterSearch(_ searchText: String) {
        activitiesViewModel.getSearchResults(searchText: searchText)
        
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
   
    func isFilteringBySearch() -> Bool {
        return !searchBarIsEmpty()
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
    
    @IBAction func okPressed(_ sender: UIButton) {
        tooSoonView.animateBounceOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.tooSoonView.isHidden = true
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource, CellCheckDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activitiesViewModel.getActivityCount(filtering: isFilteringBySearch())
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell

        cell.cellLabel.text = activitiesViewModel.getTitle(filtering: isFilteringBySearch(), index: indexPath.row)
        cell.cellCategoryLabel.text = activitiesViewModel.getCategory(filtering: isFilteringBySearch(), index: indexPath.row)

        if activitiesViewModel.checkCompleted(index: indexPath.row) {
            cell.cellCheckButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            cell.cellCheckButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }

        cell.cellDelegate = self

        return cell
    }

    func didChangeSelectedState(sender: ActivityTableViewCell, isChecked: Bool) {
        let path = self.tableView.indexPath(for: sender)
        if let selected = path {

            if isChecked {
                activitiesViewModel.checkOffActivity(index: selected.row)
            } else {
                activitiesViewModel.uncheckActivity(index: selected.row)
            }

            print("delegate called")
        }
    }
}
