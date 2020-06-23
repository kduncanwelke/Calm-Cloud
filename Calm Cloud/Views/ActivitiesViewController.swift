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
    
    var completion: [Int : Bool] = [:]
    var loaded: [ActivityId] = []
    var searchResults: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(showTooSoon), name: NSNotification.Name(rawValue: "showTooSoon"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.backgroundColor = UIColor.white
        tooSoonView.isHidden = true
        loadCompleted()
        
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
    
    func loadCompleted() {
        // load completed items
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<ActivityId>(entityName: "ActivityId")
        
        do {
            loaded = try managedContext.fetch(fetchRequest)
            
            if let lastOpened = TasksManager.lastOpened {
                // if it's a new day, removed all saved completions
                if Calendar.current.isDateInToday(lastOpened) == false {
                    for item in loaded {
                        managedContext.delete(item)
                    }
                    
                    do {
                        try managedContext.save()
                        print("deleted all")
                    } catch {
                        print("Failed to save")
                    }
                    
                    TasksManager.lastOpened = Date()
                    DataFunctions.saveTasks()
                } else {
                    // same day, no changes
                    for item in loaded {
                        completion[Int(item.id)] = true
                    }
                    
                    if loaded.count >= 3 {
                        if TasksManager.activities == false {
                            TasksManager.activities = true
                            DataFunctions.saveTasks()
                        }
                    }
                }
            } else {
                // same day, no changes
                for item in loaded {
                    completion[Int(item.id)] = true
                }
                
                if loaded.count >= 3 {
                    if TasksManager.activities == false {
                        TasksManager.activities = true
                        DataFunctions.saveTasks()
                    }
                }
            }
            
            print("entries loaded")
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func saveCompletedActivity(id: Int) {
        // save item that has been completed
        var managedContext = CoreDataManager.shared.managedObjectContext
        let activitySave = ActivityId(context: managedContext)
        
        activitySave.id = Int16(id)
        
        do {
            try managedContext.save()
            print("saved activity")
        } catch let error as NSError {
            print(error)
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
        
        loadCompleted()
    }
    
    func deleteIncompleteActivity(id: Int) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var toDelete: ActivityId
        
        for item in loaded {
            if item.id == Int16(id) {
                toDelete = item
                managedContext.delete(toDelete)
            }
        }
        
        do {
            try managedContext.save()
            print("delete successful")
        } catch {
            print("Failed to save")
        }
    }
    
    // MARK: Search bar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch(searchText)
        
        if isFilteringBySearch() == false {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("dismiss")
    }
    
    // return search results based on title and entry body text
    func filterSearch(_ searchText: String) {
        var activities: [Activity]
        
        searchResults = ActivityManager.activities.filter({(activity: Activity) -> Bool in
            return (activity.title.lowercased().contains(searchText.lowercased())) || (activity.category.rawValue.lowercased().contains(searchText.lowercased()))
        })
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [unowned self] in
            self.tooSoonView.isHidden = true
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
