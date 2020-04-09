//
//  ContentViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/6/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedLabel: UILabel!
    
    // MARK: Variables
    
    var itemIndex = PageControllerManager.currentPage
    var entry: JournalEntry?
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        savedLabel.alpha = 0.0
        textView.delegate = self
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        loadUI()
    }
    
    // MARK: Custom functions
    
    func loadUI() {
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
    
    @IBAction func savePressed(_ sender: UIButton) {
        saveEntry()
    }
    
}
