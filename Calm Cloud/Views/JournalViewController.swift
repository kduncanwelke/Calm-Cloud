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
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var darkOverlay: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var savedImage: UIImageView!
    @IBOutlet weak var viewButton: UIButton!
    
    
    // MARK: Variables
    
    let calendar = Calendar.init(identifier: .gregorian)
    var entry: JournalEntry?
    let dateFormatter = DateFormatter()
    var currentPage = 0
    var days: [Int] = []
    var direction = 0
    var monthBeginning: Date?
    var selectedFromCalendar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        savedImage.alpha = 0.0
        textView.delegate = self
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        loadUI()
        calendarView.isHidden = true
        darkOverlay.isHidden = true
        viewButton.isEnabled = false
        getCalendar()
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
    
    func getCalendar() {
        // show initial calendar page for current month
        let today = Date()
        days.removeAll()
        
        if let monthToShow = calendar.date(byAdding: .month, value: direction, to: today) {
            let comps = calendar.dateComponents([.year, .month], from: monthToShow)
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "LLLL YYYY"
            let nameOfMonth = monthFormatter.string(from: monthToShow)
            monthLabel.text = nameOfMonth
            
            if let firstOfMonth = calendar.date(from: comps) {
                monthBeginning = firstOfMonth
                let dayOfWeek = calendar.component(.weekday, from: firstOfMonth)
                
                var comps2 = DateComponents()
                comps2.month = 1
                comps2.day = -1
                let endOfMonth = Calendar.current.date(byAdding: comps2, to: firstOfMonth)
                
                if dayOfWeek != 1 {
                    let daysToAdd = dayOfWeek - 1
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
        
        // clear any preexisting index path selections when reloading collectionview
        if let selected = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selected, animated: false)
        }
        
        viewButton.isEnabled = false
        collectionView.reloadData()
    }
    
    func loadUI() {
        if currentPage == 0 {
            if EntryManager.loadedEntries.isEmpty {
                // if there are no entries add a blank one
                var managedContext = CoreDataManager.shared.managedObjectContext
                EntryManager.loadedEntries.insert(JournalEntry(context: managedContext), at: 0)
            } else {
                // if the entry's first item does not match the current date there is no entry for today, so add a blank one
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
    
    func hideCalendar() {
        calendarView.animateBounceOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [unowned self] in
            self.calendarView.isHidden = true
        }
        darkOverlay.isHidden = true
    }
    
    func displayEntry() {
        guard let currentEntry = entry, let chosenDate = currentEntry.date else {
            saveButton.isEnabled = true
            dateLabel.text = dateFormatter.string(from: Date())
            textView.text = "Start typing . . ."
            
            return
        }
        
        textView.text = currentEntry.text
        dateLabel.text = dateFormatter.string(from: chosenDate)
        saveButton.isEnabled = false
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
                collectionView.reloadData()
                saveButton.isEnabled = false
                savedImage.animateFadeInSlow()
            } catch {
                // this should never be displayed but is here to cover the possibility
                showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
            }
            
            if TasksManager.journal == false {
                TasksManager.journal = true
                DataFunctions.saveTasks()
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
            darkOverlay.isHidden = false
            calendarView.isHidden = false
            calendarView.animateBounce()
        } else {
            hideCalendar()
        }
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        saveEntry()
    }
    
    @IBAction func darkLayerTapped(_ sender: UITapGestureRecognizer) {
        hideCalendar()
    }
    
    // go left, show later month
    @IBAction func nextMonth(_ sender: UIButton) {
        direction += 1
        getCalendar()
    }
    
    // go right, show past month
    @IBAction func prevMonth(_ sender: UIButton) {
        direction -= 1
        getCalendar()
    }
    
    @IBAction func viewEntry(_ sender: UIButton) {
        if collectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            return
        }
        
        currentPage = selectedFromCalendar
        entry = EntryManager.loadedEntries[currentPage]
        displayEntry()
        hideCalendar()
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

