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
    @IBOutlet weak var waterImage: UIImageView!
    @IBOutlet weak var foodImage: UIImageView!
    
    
    // MARK: Variables
    
    var hasFood = false
    var hasWater = false
    var observation: NSKeyValueObservation?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMoving), name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        
        waterImage.isHidden = true
        foodImage.isHidden = true
        
        loadPhotos()
        loadEntries()
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        cloudKitty.image = AnimationManager.startImage
        
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed
        
        observation = cloudKitty.observe(\.isAnimating) { [weak self] imageView, change in
            if self?.cloudKitty.isAnimating == false {
                print("ended")
                self?.stopMoving()
                //self?.observation = nil
            }
            print("observe")
        }
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
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func loadEntries() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
        
        do {
            EntryManager.loadedEntries = try managedContext.fetch(fetchRequest)
            print("entries loaded")
            EntryManager.loadedEntries.reverse()
        } catch let error as NSError {
            showAlert(title: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    func randomRepeatCount() -> Int {
        var randomRepeatCount = Int.random(in: 1...6)
        return randomRepeatCount
    }
    
    // MARK: Animations
    
    // right to left movemenet
    
    func moveLeftToBed() {
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed
    }
    
    func moveLeftToWater() {
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: waterBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .water
    }
    
    // left to right movement
    
    func moveRightToFood() {
         cloudKitty.animationImages = AnimationManager.movingRightAnimation
         cloudKitty.startAnimating()
         let foodBowlDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
         cloudKitty.move(to: foodBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
         AnimationManager.location = .food
    }

    func moveRightToWater() {
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: waterBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .water
    }
    
    // bed animations
    
    func sleep() {
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = randomRepeatCount()
        cloudKitty.startAnimating()
    }
    
    func bounce() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/8, y: (container.frame.height/2)-20)
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: bedDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // food bowl animation
    
    func eat() {
        cloudKitty.animationImages = AnimationManager.eatAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        cloudKitty.animationRepeatCount = randomRepeatCount()
        AnimationManager.mood = .happy
    }
    
    func bounceNextToFood() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        
        let floatDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33-20)
        
        cloudKitty.move(to: floatDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // water bowl animations
    
    func drink() {
        cloudKitty.animationImages = AnimationManager.drinkAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        cloudKitty.animationRepeatCount = randomRepeatCount()
        AnimationManager.mood = .hungry
    }
    
    func bounceNextToWater() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 3.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/2, y: ((container.frame.height/3)*2)-20)
        
        cloudKitty.move(to: floatDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // center animations
    
    func bounceAtCenter() {
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 3.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/5, y: ((container.frame.height/3)*2)-20)
        cloudKitty.move(to: floatDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // random location-specific animations
    
    func randomBedAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            sleep()
        } else {
            bounce()
        }
    }
    
    func randomFoodAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 && hasFood {
            eat()
        } else {
            bounceNextToFood()
        }
    }
    
    func randomWaterAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 && hasWater {
            drink()
        } else {
            bounceNextToWater()
        }
    }
    
    func randomCenterAnimation() {
        bounceAtCenter()
    }
    
    // location change animations
    
    func randomMoveFromBedAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveRightToWater()
        } else {
            moveRightToFood()
        }
    }
    
    func randomMoveFromCenterAnimation() {
        let range = [1,2,3]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveLeftToBed()
        } else if animation == 2 {
            moveRightToFood()
        } else if animation == 3 {
            moveLeftToBed()
        }
    }
    
    func moveFromWater() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveRightToFood()
        } else {
            moveLeftToBed()
        }
    }
    
    func moveFromFood() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveLeftToWater()
        } else {
            moveLeftToBed()
        }
    }
    
    @objc func stopMoving() {
        var movement = Bool.random()
        cloudKitty.stopAnimating()
        
        if movement {
            print("move")
            switch AnimationManager.location {
            case .bed:
                randomMoveFromBedAnimation()
            case .food:
                moveFromFood()
            case .water:
                moveFromWater()
            case .middle:
                randomMoveFromCenterAnimation()
            case .toy:
                print("toy")
            }
        } else {
            print("place animation")
            switch AnimationManager.location {
            case .bed:
                randomBedAnimation()
            case .food:
                randomFoodAnimation()
            case .water:
                randomWaterAnimation()
            case .middle:
                randomCenterAnimation()
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
            cloudKitty.image = AnimationManager.startImage
            container.subviews.last?.removeFromSuperview()
        }
    }
    
    @IBAction func giveWater(_ sender: UITapGestureRecognizer) {
        if waterImage.isHidden {
            waterImage.isHidden = false
            hasWater = true
        } else {
            // do nothing
        }
    }
    
    @IBAction func giveFood(_ sender: UITapGestureRecognizer) {
        if foodImage.isHidden {
            foodImage.isHidden = false
            hasFood = true
        } else {
            // do nothing
        }
    }
    
    
    @IBAction func doorTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goOutside", sender: Any?.self)
    }
    
    @IBAction func remindersTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitReminders", sender: Any?.self)
    }
    
    @IBAction func favoritesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitFavorites", sender: Any?.self)
    }
    
    @IBAction func activitiesTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitActivities", sender: Any?.self)
    }
    
    @IBAction func journalTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "visitJournal", sender: Any?.self)
    }
    
}

