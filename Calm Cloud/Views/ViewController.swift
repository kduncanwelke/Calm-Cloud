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
    @IBOutlet weak var door: UIImageView!
    @IBOutlet weak var openDoor: UIImageView!
    
    
    // MARK: Variables
    
    var hasFood = false
    var hasWater = false
    var hasCleanPotty = false
    var hasEaten = false
    var hasDrunk = false
    var hasBeenPet = false
    var hasPlayed = false
    var summonedToToy = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMoving), name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnIndoors), name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        
        openDoor.isHidden = true
        
        loadPhotos()
        loadEntries()
        loadCare()
        
        loadUI()
        
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
    
    func loadUI() {
        if hasFood {
            foodImage.isHidden = false
        } else {
            foodImage.isHidden = true
        }
        
        if hasWater {
            waterImage.isHidden = false
        } else {
            waterImage.isHidden = true
        }
        
        if hasCleanPotty {
            pottyBox.image = UIImage(named: "litterbox")
        }
    }
    
    @objc func returnIndoors() {
        door.isHidden = false
        openDoor.isHidden = true
    }
    
    func randomRepeatCount() -> Int {
        var randomRepeatCount = Int.random(in: 4...8)
        return randomRepeatCount
    }
    
    func setMood() {
        if hasFood == false && hasWater == false && hasCleanPotty == false {
            AnimationManager.mood = .sad
        } else if hasFood == true && hasWater == false {
            AnimationManager.mood = .thirsty
        } else if hasWater == true && hasFood == false {
            AnimationManager.mood = .hungry
        } else if hasCleanPotty == false {
            AnimationManager.mood = .unhappy
        } else if hasCleanPotty && hasFood == false && hasWater == false {
            AnimationManager.mood = .unhappy
        } else if (hasPlayed || hasBeenPet) && hasFood == false && hasWater == false {
            AnimationManager.mood = .unhappy
        } else if hasFood && hasWater {
            AnimationManager.mood = .happy
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
        
        let destination: CGPoint
        
        switch AnimationManager.location {
        case .bed:
            destination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
        case .food:
            destination = CGPoint(x: container.frame.width/1.66, y: (container.frame.height/3)*2.33)
        case .water:
            destination = CGPoint(x: container.frame.width/2.45, y: (container.frame.height/3)*2.33)
        case .middle:
            destination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*2)
        case .toy:
            destination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        }
        
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMove(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
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
        setMood()
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
        setMood()
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
        setMood()
    }
    
    // center animations
    
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
            bounce()
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
            bounce()
        }
    }
    
    func randomToyAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if summonedToToy {
            play()
            summonedToToy = false
        } else if animation == 1 {
            play()
        } else {
            bounce()
        }
    }
    
    func randomCenterAnimation() {
        bounce()
    }
    
    // location change animations
    
    func randomMove() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            switch AnimationManager.location {
            case .bed:
                moveRightToWater()
            case .food:
                moveLeftToWater()
            case .water:
                moveRightToFood()
            case .middle:
                moveLeftToBed()
            case .toy:
                moveLeftToBed()
            }
        } else if animation == 2 {
            switch AnimationManager.location {
            case .bed:
                moveRightToFood()
            case .food:
                moveLeftToBed()
            case .water:
               moveLeftToBed()
            case .middle:
               moveRightToFood()
            case .toy:
                moveLeftToWater()
            }
        } else if animation == 3 {
            switch AnimationManager.location {
            case .bed:
                moveRightToToy()
            case .food:
                 moveRightToToy()
            case .water:
                moveRightToToy()
            case .middle:
                moveLeftToBed()
            case .toy:
                moveLeftToFood()
            }
        } else {
            switch AnimationManager.location {
            case .bed:
                moveRightToCenter()
            case .food:
                moveLeftToCenter()
            case .water:
                moveRightToCenter()
            case .middle:
                moveRightToToy()
            case .toy:
                moveLeftToCenter()
            }
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
            AnimationManager.movement = .moving
            if summonedToToy && AnimationManager.location != .toy {
                if Bool.random() {
                    moveRightToToy()
                } else {
                    randomMove()
                }
            } else {
                randomMove()
            }
        } else if animation == 2 {
            print("place animation")
            AnimationManager.movement = .staying
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
            AnimationManager.movement = .staying
            print("sleep from stopmoving")
            if summonedToToy && AnimationManager.location == .toy {
                if Bool.random() {
                    play()
                } else {
                    sleep()
                }
            } else {
                sleep()
            }
        } else {
            AnimationManager.movement = .staying
            print("pause")
            if summonedToToy && AnimationManager.location == .toy {
                if Bool.random() {
                    play()
                } else {
                    pause()
                }
            } else {
                pause()
            }
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
        if hasWater {
            // do nothing
        } else {
            waterImage.isHidden = false
            hasWater = true
            saveCare(food: nil, water: Date(), potty: nil)
        }
    }
    
    @IBAction func giveFood(_ sender: UITapGestureRecognizer) {
        if hasFood {
            // do nothing
        } else {
            foodImage.isHidden = false
            hasFood = true
            saveCare(food: Date(), water: nil, potty: nil)
        }
    }
    
    @IBAction func tapOnToy(_ sender: UITapGestureRecognizer) {
        toyImage.animationImages = AnimationManager.toyAnimation
        toyImage.animationDuration = 0.3
        toyImage.animationRepeatCount = 2
        toyImage.startAnimating()
        summonedToToy = true
    }
    
    @IBAction func cleanPotty(_ sender: UITapGestureRecognizer) {
        if hasCleanPotty {
            // do nothing
        } else {
            hasCleanPotty = true
            pottyBox.image = UIImage(named: "litterbox")
            saveCare(food: nil, water: nil, potty: Date())
        }
    }
    
    
    @IBAction func doorTapped(_ sender: UITapGestureRecognizer) {
        door.isHidden = true
        openDoor.isHidden = false
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

