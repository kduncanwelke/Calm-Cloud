//
//  JournalViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class JournalViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Variables
    
    let calendar = Calendar.current
    var entry: JournalEntry?
    let dateFormatter = DateFormatter()
    var currentPage = 0
    var days: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        savedLabel.alpha = 0.0
        textView.delegate = self
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        loadUI()
        calendarView.isHidden = true
        getCalendar()
    }

    // MARK: Custom functions
    
    func getCalendar() {
        let today = Date()
        let comps = calendar.dateComponents([.year, .month], from: today)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        let nameOfMonth = monthFormatter.string(from: today)
        monthLabel.text = nameOfMonth
        
        if let firstOfMonth = calendar.date(from: comps) {
            let dayOfWeek = calendar.component(.weekday, from: firstOfMonth)
            
            var comps2 = DateComponents()
            comps2.month = 1
            comps2.day = -1
            let endOfMonth = Calendar.current.date(byAdding: comps2, to: firstOfMonth)
            
            if dayOfWeek != 1 {
                let daysToAdd = dayOfWeek
                for day in 1...daysToAdd {
                    days.append(0)
                }
            }
            
            if let end = endOfMonth {
                let endDay = calendar.component(.day, from: end)
                
                for day in 1...endDay {
                    days.append(day)
                }
            }
        }
    }
    
    func loadUI() {
        if currentPage == 0 {
            if EntryManager.loadedEntries.isEmpty {
                // if there are no entries add a blank one
                var managedContext = CoreDataManager.shared.managedObjectContext
                EntryManager.loadedEntries.insert(JournalEntry(context: managedContext), at: 0)
            } else {
                // if the entrie's first item does not match the current date there is no entry for today, so add a blank one
                if let firstEntry = EntryManager.loadedEntries.first, let dateofEntry = firstEntry.date {
                    let entryIsForToday = calendar.isDate(dateofEntry, inSameDayAs: Date())
                    
                    if entryIsForToday == false {
                        var managedContext = CoreDataManager.shared.managedObjectContext
                        EntryManager.loadedEntries.insert(JournalEntry(context: managedContext), at: 0)
                    }
                }
            }
        }
        
        if EntryManager.loadedEntries.count > 0 {
            entry = EntryManager.loadedEntries[currentPage]
        }
            
        displayEntry()
    }
    
    func displayEntry() {
        guard let currentEntry = entry, let chosenDate = currentEntry.date else {
            saveButton.isHidden = false
            dateLabel.text = dateFormatter.string(from: Date())
            
            return
        }
        
        textView.text = currentEntry.text
        dateLabel.text = dateFormatter.string(from: chosenDate)
        saveButton.isHidden = true
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            // test on different size devices to make sure it works
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (0.66*keyboardViewEndFrame.height) - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func saveEntry() {
        if textView.text != nil && textView.text != "Start typing . . ." {
            
            var managedContext = CoreDataManager.shared.managedObjectContext
            
            entry?.date = Date()
            entry?.text = textView.text
            
            // remove empty placeholder
            EntryManager.loadedEntries.remove(at: 0)
            
            guard let newEntry = entry else { return }
            
            EntryManager.loadedEntries.insert(newEntry, at: 0)
            
            do {
                try managedContext.save()
                print("saved entry")
                saveButton.isHidden = true
                savedLabel.animateFadeIn()
            } catch {
                // this should never be displayed but is here to cover the possibility
                showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
            }
        } else {
            print("text view was empty or nil")
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
    
    @IBAction func calendarPressed(_ sender: UIBarButtonItem) {
        if calendarView.isHidden {
            calendarView.isHidden = false
            calendarView.animateBounce()
        } else {
            calendarView.animateBounce()
            calendarView.isHidden = true
        }
    }
   
    @IBAction func savePressed(_ sender: UIButton) {
        saveEntry()
    }
    
    @IBAction func forwardPressed(_ sender: UIButton) {
        if currentPage > 0 {
            currentPage -= 1
            entry = EntryManager.loadedEntries[currentPage]
            displayEntry()
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if currentPage < EntryManager.loadedEntries.count - 1 {
            currentPage += 1
            entry = EntryManager.loadedEntries[currentPage]
            displayEntry()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

