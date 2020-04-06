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
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Variables
    
    var itemIndex = PageControllerManager.currentPage
    var entry: JournalEntry?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textView.delegate = self
        loadUI()
    }
    
    // MARK: Custom functions
    
    func loadUI() {
        guard let currentEntry = entry else {
            saveButton.isHidden = false
            
            return
        }
        
        textView.text = currentEntry.text
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
        if textView.text != nil && textView.text != "" {
            
            var managedContext = CoreDataManager.shared.managedObjectContext
            
            let newJournalSave = JournalEntry(context: managedContext)
            newJournalSave.date = Date()
            newJournalSave.text = textView.text
            EntryManager.loadedEntries.append(newJournalSave)
            
            do {
                try managedContext.save()
                print("saved entry")
            } catch {
                // this should never be displayed but is here to cover the possibility
                //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
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
