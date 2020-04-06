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
            
        // if no entry exists for current day, add blank page
        self.setViewControllers(contentControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
    // create content view
    func getContentViewController(withIndex index: Int) -> ContentViewController? {
        var contentVC = self.storyboard?.instantiateViewController(withIdentifier: "contentVC") as! ContentViewController
        contentVC.itemIndex = index
        contentVC.entry = EntryManager.loadedEntries[index]
            
        return contentVC
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
