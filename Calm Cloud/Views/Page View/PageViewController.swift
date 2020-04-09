//
//  PageViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/6/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    // MARK: Variables
    
    var pendingIndex: Int?
    let calendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
        createPageViewController()
    }
    

    func createPageViewController() {
        var contentController = getContentViewController(withIndex: PageControllerManager.currentPage)!
        var contentControllers = [contentController]
            
        self.setViewControllers(contentControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
    // create content view
    func getContentViewController(withIndex index: Int) -> ContentViewController? {
        if index == 0 {
            if EntryManager.loadedEntries.isEmpty {
                // if there are no entries add a blank one
                var managedContext = CoreDataManager.shared.managedObjectContext
                EntryManager.loadedEntries.insert(JournalEntry(context: managedContext), at: 0)
            } else {
                // if there are enrties first item does not match the current date there is no entry for today, so add a blank one
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
            var contentVC = self.storyboard?.instantiateViewController(withIdentifier: "contentVC") as! ContentViewController
            contentVC.itemIndex = index
            contentVC.entry = EntryManager.loadedEntries[index]
                
            return contentVC
        } else {
            return nil
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

}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var contentVC = viewController as! ContentViewController
        
        if contentVC.itemIndex > 0 {
            return getContentViewController(withIndex: contentVC.itemIndex - 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var contentVC = viewController as! ContentViewController
        
        if contentVC.itemIndex + 1 < EntryManager.loadedEntries.count {
            return getContentViewController(withIndex: contentVC.itemIndex + 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = (pendingViewControllers.first as! ContentViewController).itemIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentIndex = pendingIndex
            if let index = currentIndex {
                PageControllerManager.currentPage = index
                print(PageControllerManager.currentPage)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sectionChanged"), object: nil)
            }
        }
    }
}
