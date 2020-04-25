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
    @IBOutlet weak var toyImage: UIImageView!
    @IBOutlet weak var pottyBox: UIImageView!
    
    // MARK: Variables
    
    var hasFood = false
    var hasWater = false
    var hasCleanPotty = false
    var hasEaten = false
    var hasDrunk = false
    var hasBeenPet = false
    var hasPlayed = false
    
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
        
        sleep()
        AnimationManager.location = .middle
        setMood()
        /*cloudKitty.image = AnimationManager.startImage
        
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed*/
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
        var randomRepeatCount = Int.random(in: 2...6)
        return randomRepeatCount
    }
    
    func setMood() {
        if hasDrunk == false {
            AnimationManager.mood = .thirsty
        } else if hasEaten == false {
            AnimationManager.mood = .hungry
        } else if hasPlayed || hasBeenPet {
            AnimationManager.mood = .unhappy
        } else if hasEaten && hasDrunk {
            AnimationManager.mood = .happy
        } else {
            AnimationManager.mood = .sad
        }
    }
    
    func adjustMood() {
        switch AnimationManager.mood {
        case .happy:
            if hasEaten && hasDrunk {
                // no change
            } else if hasEaten && hasDrunk == false {
                AnimationManager.mood = .thirsty
            } else if hasDrunk && hasEaten == false {
                AnimationManager.mood = .hungry
            } else if hasBeenPet || hasPlayed {
                AnimationManager.mood = .unhappy
            } else {
                AnimationManager.mood = .sad
            }
        case .hungry:
            if hasEaten && hasDrunk {
                AnimationManager.mood = .happy
            } else if hasEaten && hasDrunk == false {
                AnimationManager.mood = .thirsty
            } else if hasEaten == false && hasDrunk == false {
                AnimationManager.mood = .sad
            } else if hasBeenPet || hasPlayed {
                AnimationManager.mood = .unhappy
            } else {
                // no change
            }
        case .thirsty:
            if hasDrunk && hasEaten {
                AnimationManager.mood = .happy
            } else if hasDrunk && hasEaten == false {
                AnimationManager.mood = .hungry
            } else if hasEaten == false && hasDrunk == false {
                AnimationManager.mood = .sad
            } else if hasBeenPet || hasPlayed {
                AnimationManager.mood = .unhappy
            } else {
                // no change
            }
        case .sad:
            if hasEaten && hasDrunk {
                AnimationManager.mood = .happy
            } else if hasEaten && hasDrunk == false {
                AnimationManager.mood = .thirsty
            } else if hasEaten == false && hasDrunk {
                AnimationManager.mood = .hungry
            } else if hasBeenPet || hasPlayed {
                AnimationManager.mood = .unhappy
            } else {
                // no change
            }
        case .unhappy:
            if hasEaten && hasDrunk {
                AnimationManager.mood = .happy
            } else if hasEaten && hasDrunk == false {
                AnimationManager.mood = .thirsty
            } else if hasEaten == false && hasDrunk {
                AnimationManager.mood = .hungry
            } else if hasBeenPet || hasPlayed {
                // no change
            } else {
                AnimationManager.mood = .sad
            }
        }
    }
    
    // MARK: Animations
    
    // right to left movemenet
    
    func moveLeftToBed() {
        print("left to bed")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        cloudKitty.move(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .bed
    }
    
    func moveLeftToFood() {
        print("left to food")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let foodBowlDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: foodBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .food
    }

    func moveLeftToWater() {
        print("left to water")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: waterBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .water
    }
    
    func moveLeftToCenter() {
        print("left to center")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        cloudKitty.move(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .middle
    }
    
    // left to right movement
    
    func moveRightToFood() {
         print("right to food")
         cloudKitty.animationImages = AnimationManager.movingRightAnimation
         cloudKitty.startAnimating()
         let foodBowlDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
         cloudKitty.move(to: foodBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
         AnimationManager.location = .food
    }

    func moveRightToWater() {
        print("right to water")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        cloudKitty.move(to: waterBowlDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .water
    }
    
    func moveRightToToy() {
        print("right to toy")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let toyDestination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        cloudKitty.move(to: toyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .toy
    }
    
    func moveRightToCenter() {
        print("right to center")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        cloudKitty.move(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .middle
    }
    
    // bed animations
    
    func sleep() {
        print("sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func bounce() {
        print("bounce")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/8, y: (container.frame.height/2)-20)
        let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: bedDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // food bowl animation
    
    func eat() {
        print("eat")
        cloudKitty.animationImages = AnimationManager.eatAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
        hasEaten = true
        adjustMood()
    }
    
    func bounceNextToFood() {
        print("bounce at food")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33-20)
        let foodBowlDestination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: foodBowlDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // water bowl animations
    
    func drink() {
        print("drink")
        cloudKitty.animationImages = AnimationManager.drinkAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
        hasDrunk = true
        adjustMood()
    }
    
    func bounceNextToWater() {
        print("bounce at water")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 3.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33-20)
        let waterBowlDestination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: waterBowlDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // toy animations
    
    func play() {
        print("play")
        cloudKitty.animationImages = AnimationManager.playAnimation
        toyImage.animationImages = AnimationManager.toyAnimation
        cloudKitty.animationDuration = 1.0
        toyImage.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        toyImage.animationRepeatCount = 0
        cloudKitty.startAnimating()
        toyImage.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
        hasPlayed = true
        adjustMood()
    }
    
    func bounceNextToToy() {
        print("bounce at toy")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4-20)
        let toyDestination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: toyDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // center animations
    
    func bounceAtCenter() {
        print("bounce at center")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 3.0
        cloudKitty.startAnimating()
        let floatDestination = CGPoint(x: container.frame.width/2, y: ((container.frame.height/3)*2)-20)
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        
        cloudKitty.floatMove(to: floatDestination, returnTo: centerDestination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    func pause() {
        cloudKitty.image = AnimationManager.startImage
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
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
        
        if hasEaten == false && hasFood {
            eat()
        } else if animation == 1 && hasFood {
            eat()
        } else {
            bounceNextToFood()
        }
    }
    
    func randomWaterAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if hasDrunk == false && hasWater {
            drink()
        } else if animation == 1 && hasWater {
            drink()
        } else {
            bounceNextToWater()
        }
    }
    
    func randomToyAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            play()
        } else {
            bounceNextToToy()
        }
    }
    
    func randomCenterAnimation() {
        bounceAtCenter()
    }
    
    // location change animations
    
    func randomMoveFromBedAnimation() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveRightToWater()
        } else if animation == 2 {
            moveRightToFood()
        } else if animation == 3{
            moveRightToToy()
        } else {
            moveRightToCenter()
        }
    }
    
    func randomMoveFromToy() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveLeftToBed()
        } else if animation == 2 {
            moveLeftToWater()
        } else if animation == 3 {
            moveLeftToFood()
        } else {
            moveLeftToCenter()
        }
    }
    
    func randomMoveFromCenterAnimation() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveLeftToBed()
        } else if animation == 2 {
            moveRightToFood()
        } else if animation == 3 {
            moveLeftToBed()
        } else {
            moveRightToToy()
        }
    }
    
    func moveFromWater() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveRightToFood()
        } else if animation == 2 {
            moveLeftToBed()
        } else if animation == 3 {
            moveRightToToy()
        } else {
            moveRightToCenter()
        }
    }
    
    func moveFromFood() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            moveLeftToWater()
        } else if animation == 2 {
            moveLeftToBed()
        } else if animation == 3 {
            moveRightToToy()
        } else {
            moveLeftToCenter()
        }
    }
    
    @objc func stopMoving() {
        print("stop moving called")
        let range = [1,2,3,4]
        let animation = range.randomElement()
        cloudKitty.stopAnimating()
        if toyImage.isAnimating {
            toyImage.stopAnimating()
        }
        
        if animation == 1 {
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
                randomMoveFromToy()
            }
        } else if animation == 2 {
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
                randomToyAnimation()
            }
        } else if animation == 3 {
            print("sleep from stopmoving")
            sleep()
        } else {
            print("pause")
            pause()
        }
    }
    
    // MARK: IBActions

    @IBAction func catTouched(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            cloudKitty.animationImages = AnimationManager.heartsAnimation
            cloudKitty.animationDuration = 0.5
            cloudKitty.startAnimating()
            hasBeenPet = true
        } else if sender.state == .ended || sender.state == .cancelled {
            cloudKitty.stopAnimating()
            stopMoving()
            cloudKitty.image = AnimationManager.startImage
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
    
    @IBAction func cleanPotty(_ sender: UITapGestureRecognizer) {
        if hasCleanPotty {
            // do nothing
        } else {
            hasCleanPotty = true
            pottyBox.image = UIImage(named: "litterbox")
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

