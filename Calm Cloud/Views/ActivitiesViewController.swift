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
    
    
    // MARK: Variables
    
    var completion: [Int : Bool] = [:]
    var loaded: [ActivityId] = []
    let userDefaultDate = "userDefaultDate"
    var searchResults: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.backgroundColor = UIColor.white
        
        loadCompleted()
    }
    
    func isSameDay() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let dateToCompare = calendar.component(.day , from: date)
        
        let userDefaultDate = UserDefaults.standard.integer(forKey: "userDefaultDate")
        
        if userDefaultDate != dateToCompare {
            UserDefaults.standard.set(dateToCompare, forKey: self.userDefaultDate)
            return false
        } else {
            return true
        }
    }
    
    func loadCompleted() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<ActivityId>(entityName: "ActivityId")
        
        do {
            loaded = try managedContext.fetch(fetchRequest)
            
            if isSameDay() {
                for item in loaded {
                    completion[Int(item.id)] = true
                }
            } else {
                for item in loaded {
                    managedContext.delete(item)
                }
                
                do {
                    try managedContext.save()
                    print("deleted all")
                } catch {
                    print("Failed to save")
                }
            }
            
            print("entries loaded")
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func saveCompletedActivity(id: Int) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        let activitySave = ActivityId(context: managedContext)
        
        activitySave.id = Int16(id)
        
        do {
            try managedContext.save()
            print("saved activity")
        } catch {
            // this should never be displayed but is here to cover the possibility
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
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
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearch(searchText)
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
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
