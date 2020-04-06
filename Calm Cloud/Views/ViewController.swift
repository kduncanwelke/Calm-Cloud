//
//  ViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/20/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cloudKitty: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMoving), name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        
        loadPhotos()
        loadEntries()
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        
        
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed
        //cloudKitty.move(to: bowlsDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        
        
    }
    
    // MARK: Custom functions
    
    func loadPhotos() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        
        do {
            PhotoManager.loadedPhotos = try managedContext.fetch(fetchRequest)
            print("photos loaded")
            PhotoManager.photos.removeAll()
            DocumentsManager.filePaths.removeAll()
            
            for photoItem in PhotoManager.loadedPhotos {
                guard let filePath = photoItem.path else { return }
                let path = DocumentsManager.documentsURL.appendingPathComponent(filePath).path
                if FileManager.default.fileExists(atPath: path) {
                    if let contents = UIImage(contentsOfFile: path) {
                        PhotoManager.photos.append(contents)
                        DocumentsManager.filePaths.append(filePath)
                    }
                } else {
                    print("not found")
                }
            }
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func loadEntries() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
        
        do {
            EntryManager.loadedEntries = try managedContext.fetch(fetchRequest)
            print("entries loaded")
        } catch let error as NSError {
            //showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    // MARK: Animations
    
    func randomMoveFromCenterAnimation() {
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed
    }
    
    func randomMoveFromBedAnimation() {
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let bowlsDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        cloudKitty.move(to: bowlsDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bowls
    }
    
    func randomBedAnimation() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/8, y: (container.frame.height/2)-20)
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: bedDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }

    func randomBowlAnimation() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 3.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/2, y: ((container.frame.height/3)*2)-20)
        
        cloudKitty.move(to: floatDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    func randomCenterAnimation() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 3.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/5, y: ((container.frame.height/3)*2)-20)
        cloudKitty.move(to: floatDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    @objc func stopMoving() {
        var movement = Bool.random()
        cloudKitty.stopAnimating()
        
        if movement {
            print("move")
            switch AnimationManager.location {
            case .bed:
                randomMoveFromBedAnimation()
            case .bowls:
                print("bowls")
            case .middle:
                randomMoveFromCenterAnimation()
            case .toy:
                print("toy")
            }
            
        } else {
            print("bounce")
            switch AnimationManager.location {
            case .bed:
                randomBedAnimation()
            case .bowls:
               randomBowlAnimation()
            case .middle:
                print("middle")
            case .toy:
                print("toy")
            }
        }
    }
    
    // MARK: IBActions

    @IBAction func catTouched(_ sender: UIPanGestureRecognizer) {
        let heart = UIImage(named: "heart")
        let heartImageView = UIImageView(image: heart)
        heartImageView.frame = CGRect(x: cloudKitty.frame.midX, y: cloudKitty.frame.minY, width: cloudKitty.frame.height/3, height: cloudKitty.frame.height/3)
        heartImageView.animationImages = AnimationManager.heartsAnimation
        heartImageView.animationDuration = 0.5
        
        if sender.state == .began {
            cloudKitty.image = UIImage(named: "purr")
            container.addSubview(heartImageView)
            heartImageView.startAnimating()
        } else if sender.state == .ended || sender.state == .cancelled {
            cloudKitty.image = UIImage(named: "cloudkitty")
            container.subviews.last?.removeFromSuperview()
        }
    }
    
    
    @IBAction func remindersTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitReminders", sender: Any?.self)
    }
    
    @IBAction func favoritesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitFavorites", sender: Any?.self)
    }
    
    @IBAction func journalTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitJournal", sender: Any?.self)
    }
    
}

