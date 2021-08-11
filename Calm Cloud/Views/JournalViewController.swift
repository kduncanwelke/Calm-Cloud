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

    private let journalViewModel = JournalViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        savedImage.alpha = 0.0
        textView.delegate = self

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
        journalViewModel.configureCalendar()
        monthLabel.text = journalViewModel.getMonthName()

        // clear any preexisting index path selections when reloading collectionview
        if let selected = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selected, animated: false)
        }
        
        viewButton.isEnabled = false
        collectionView.reloadData()
    }
    
    func loadUI() {
        journalViewModel.configureEntry()
            
        displayEntry()
    }
    
    func hideCalendar() {
        calendarView.animateBounceOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.calendarView.isHidden = true
        }
        darkOverlay.isHidden = true
    }
    
    func displayEntry() {
        textView.isEditable = journalViewModel.isEditable()
        textView.text = journalViewModel.getEntryText()
        dateLabel.text = journalViewModel.getEntryDate()
        saveButton.isEnabled = journalViewModel.saveButtonEnabled()
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

    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText {
            saveButton.isEnabled = true
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
        textView.resignFirstResponder()
        
        if journalViewModel.saveEntry(text: textView.text) != nil {
            collectionView.reloadData()
            saveButton.isEnabled = false
            savedImage.animateFadeInSlow()
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        // if text view is active and user taps off of it, dismiss
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func darkLayerTapped(_ sender: UITapGestureRecognizer) {
        hideCalendar()
    }
    
    // go left, show later month
    @IBAction func nextMonth(_ sender: UIButton) {
        journalViewModel.increaseDirection()
        getCalendar()
    }
    
    // go right, show past month
    @IBAction func prevMonth(_ sender: UIButton) {
        journalViewModel.decreaseDirection()
        getCalendar()
    }
    
    @IBAction func viewEntry(_ sender: UIButton) {
        if collectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            return
        }

        journalViewModel.viewEntry()
        displayEntry()
        hideCalendar()
    }

    @IBAction func forwardPressed(_ sender: UIButton) {
        if journalViewModel.goForward() {
            displayEntry()
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if journalViewModel.goBackward() {
            displayEntry()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JournalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journalViewModel.getDayCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell

        cell.dateLabel.text = journalViewModel.getDateLabel(index: indexPath.row)
        cell.backgroundColor = journalViewModel.getBackgroundColor(index: indexPath.row)
        cell.checkMark.isHidden = journalViewModel.isCheckMarkHidden(index: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! CalendarCollectionViewCell

        if journalViewModel.isDayViewable(index: indexPath.row) == false {
            tappedCell.backgroundColor = .white
            viewButton.isEnabled = false
            return
        }

        if journalViewModel.selected(index: indexPath.row) {
            tappedCell.backgroundColor = Colors.blue
            viewButton.isEnabled = true
        } else {
            viewButton.isEnabled = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! CalendarCollectionViewCell

        tappedCell.backgroundColor = journalViewModel.getBackgroundColor(index: indexPath.row)
        viewButton.isEnabled = false
        collectionView.deselectItem(at: indexPath, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let maxNumColumns = 7
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

        return CGSize(width: cellWidth, height: cellWidth)
    }
}


