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
    @IBOutlet weak var nightOverlay: UIView!
    @IBOutlet weak var lightsOffButton: UIButton!
    @IBOutlet weak var darkOutside: UIView!
    
    
    // MARK: Variables
    
    var hasFood = false
    var hasWater = false
    var hasCleanPotty = false
    var hasEaten = false
    var hasDrunk = false
    var hasBeenPet = false
    var hasPlayed = false
    var summonedToFood = false
    var summonedToWater = false
    var summonedToToy = false
    var summonedToPotty = false
    var inPotty = false
    var stopped = false
    var lightsOff = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMoving), name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnIndoors), name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToSleep), name: NSNotification.Name(rawValue: "goToSleep"), object: nil)
        
        openDoor.isHidden = true
       
        // load sounds
        Sound.loadSound(resourceName: Sounds.calmMusic.resourceName, type: Sounds.calmMusic.type)
        
        loadPhotos()
        loadEntries()
        loadCare()
        
        loadUI()
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        sleep()
        AnimationManager.location = .middle
        setMood()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: Custom functions
    
    func loadUI() {
        if hasFood {
            foodImage.isHidden = false
            hasEaten = true
        } else {
            foodImage.isHidden = true
        }
        
        if hasWater {
            waterImage.isHidden = false
            hasDrunk = true
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
        stopped = false
        stopMoving()
    }
    
    @objc func goToSleep() {
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
    }
    
    func randomRepeatCount() -> Int {
        var randomRepeatCount = Int.random(in: 4...8)
        return randomRepeatCount
    }
    
    func setMood() {
        if hasFood == false && hasWater == false && hasCleanPotty == false {
            AnimationManager.mood = .sad
        } else if hasEaten == true && hasDrunk == false {
            AnimationManager.mood = .thirsty
        } else if hasDrunk == true && hasEaten == false {
            AnimationManager.mood = .hungry
        } else if hasCleanPotty == false {
            AnimationManager.mood = .embarrassed
        } else if hasCleanPotty && hasFood == false && hasWater == false {
            AnimationManager.mood = .unhappy
        } else if (hasPlayed || hasBeenPet) && hasFood == false && hasWater == false {
            AnimationManager.mood = .unhappy
        } else if hasEaten && hasDrunk {
            AnimationManager.mood = .happy
        }
    }
    
    // MARK: Animations
    
    func floatUp() {
        print("float")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        cloudKitty.move(to: ceilingDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .ceiling
    }
    
    // left movemenet
    
    func floatLeft() {
        print("float left")
        cloudKitty.animationImages = AnimationManager.upsideDownLeft
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/6)
        cloudKitty.move(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
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
    
    func moveLeftToToy() {
        print("right to toy")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let toyDestination = CGPoint(x: container.frame.width/1.4, y: (container.frame.height/3)*2.4)
        cloudKitty.move(to: toyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .toy
    }
    
    // right movement
    
    func floatRight() {
        print("float right")
        cloudKitty.animationImages = AnimationManager.upsideDownRight
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/1.12, y: container.frame.height/6)
        cloudKitty.move(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
    }
    
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
    
    func moveRightToPotty() {
        print("right to potty")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let pottyDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2)
        cloudKitty.move(to: pottyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .potty
    }
    
    func moveIntoPotty() {
        print("potty")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let pottyDestination = CGPoint(x: container.frame.width/1.12, y: (container.frame.height/3)*1.55)
        cloudKitty.move(to: pottyDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.location = .potty
        inPotty = true
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
        case .potty:
            destination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2)
        case .ceiling:
            destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY)
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
    
    // litter box animations
    
    func dig() {
        print("dig")
        cloudKitty.animationImages = AnimationManager.digAnimation
        cloudKitty.animationDuration = 1.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    // ceiling animations
    
    func floatSleep() {
        print("float sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        let destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY)
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMove(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    // place non-specific animations
    
    func pause() {
        cloudKitty.image = AnimationManager.startImage
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func linger() {
        print("linger")
        cloudKitty.animationImages = AnimationManager.lingerAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
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
        let range = [1,2,3]
        let animation = range.randomElement()
        
        if summonedToFood {
            summonedToFood = false
        }
        
        if hasEaten == false && hasFood {
            eat()
        } else if hasEaten == false && hasFood == false {
            linger()
        } else if animation == 1 && hasFood {
            eat()
        } else if animation == 2 {
            linger()
        } else {
            bounce()
        }
    }
    
    func randomWaterAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if summonedToWater {
            summonedToWater = false
        }
        
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
    
    func randomPottyAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if summonedToPotty {
            summonedToPotty = false
        }
        
        if inPotty {
            dig()
        } else {
            if hasCleanPotty == false {
                linger()
            } else if animation == 1 {
                moveIntoPotty()
            } else {
                linger()
            }
        }
    }
    
    func randomCenterAnimation() {
        bounce()
    }
    
    func randomCeilingAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            floatLeft()
        } else {
            floatRight()
        }
    }
    
    // location change animations
    
    func randomMove() {
        let range = [1,2,3,4,5]
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
            case .potty:
                moveLeftToBed()
            case .ceiling:
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
            case .potty:
                moveLeftToFood()
            case .ceiling:
               moveRightToToy()
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
            case .potty:
                moveLeftToWater()
            case .ceiling:
                moveLeftToWater()
            }
        } else if animation == 4 {
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
            case .potty:
                moveLeftToToy()
            case .ceiling:
                moveRightToFood()
            }
        } else {
            if AnimationManager.mood == .happy && AnimationManager.location != .ceiling {
                floatUp()
            } else {
                randomMove()
            }
        }
    }
    
    func summoned() {
        if summonedToToy && AnimationManager.location != .toy && hasPlayed == false {
            moveRightToToy()
        } else if summonedToWater && hasDrunk == false {
            switch AnimationManager.location {
            case .water:
                drink()
            case .bed:
                moveRightToWater()
            case .food:
                moveLeftToWater()
            case .middle:
                moveLeftToWater()
            case .toy:
                moveLeftToWater()
            case .potty:
                moveLeftToWater()
            case .ceiling:
                moveLeftToWater()
            }
        } else if summonedToFood && hasEaten == false {
            switch AnimationManager.location {
            case .food:
                eat()
            case .bed:
                moveRightToFood()
            case .water:
                moveRightToFood()
            case .middle:
                moveRightToFood()
            case .toy:
                moveLeftToFood()
            case .potty:
                moveLeftToFood()
            case .ceiling:
                moveRightToFood()
            }
        } else if hasFood == false {
            switch AnimationManager.location {
            case .food:
                linger()
            case .bed:
                moveRightToFood()
            case .water:
                moveRightToFood()
            case .middle:
                moveRightToFood()
            case .toy:
                moveLeftToFood()
            case .potty:
                moveLeftToFood()
            case .ceiling:
                moveRightToFood()
            }
        } else if hasCleanPotty == false {
            moveRightToPotty()
        } else {
            randomMove()
        }
    }
    
    @objc func stopMoving() {
        print("stop moving called")
        let range = [1,2,3,4]
        let animation = range.randomElement()
        cloudKitty.stopAnimating()
        
        if stopped {
            return
        }
        
        if toyImage.isAnimating {
            toyImage.stopAnimating()
        }
        
        if inPotty {
            inPotty = false
            summoned()
        }
        
        if animation == 1 {
            print("move")
            AnimationManager.movement = .moving
            summoned()
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
            case .potty:
                randomPottyAnimation()
            case .ceiling:
                randomCeilingAnimation()
            }
        } else if animation == 3 {
            AnimationManager.movement = .staying
            print("sleep from stopmoving")
            switch AnimationManager.location {
            case .ceiling:
                floatSleep()
            default:
                sleep()
            }
        } else {
            AnimationManager.movement = .staying
            print("pause")
            switch AnimationManager.location {
            case .ceiling:
                bounce()
            default:
                pause()
            }
        }
    }
    
    // MARK: IBActions

    @IBAction func catTouched(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if AnimationManager.movement == .staying {
                AnimationTimer.stop()
                cloudKitty.stopAnimating()
                cloudKitty.animationImages = AnimationManager.petAnimation
                cloudKitty.animationDuration = 1.0
                cloudKitty.startAnimating()
                hasBeenPet = true
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if lightsOff {
                goToSleep()
            } else {
                stopMoving()
            }
        }
    }
    
    @IBAction func giveWater(_ sender: UITapGestureRecognizer) {
        summonedToWater = true
        
        if hasWater {
            // do nothing
        } else {
            waterImage.isHidden = false
            hasWater = true
            saveCare(food: nil, water: Date(), potty: nil)
        }
    }
    
    @IBAction func giveFood(_ sender: UITapGestureRecognizer) {
        summonedToFood = true
        
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
            setMood()
        }
    }
    
    @IBAction func doorTapped(_ sender: UITapGestureRecognizer) {
        door.isHidden = true
        openDoor.isHidden = false
        AnimationTimer.stop()
        stopped = true
        performSegue(withIdentifier: "goOutside", sender: Any?.self)
    }
    
    @IBAction func lightsOffTapped(_ sender: UIButton) {
        if lightsOff {
            darkOutside.fadeOut()
            nightOverlay.fadeOut()
            lightsOffButton.setBackgroundImage(UIImage(named: "lightsoff"), for: .normal)
            lightsOffButton.setTitle("  Lights Off", for: .normal)
            lightsOffButton.setTitleColor(UIColor.white, for: .normal)
            lightsOff = false
            stopped = false
            Sound.stopPlaying()
            stopMoving()
        } else {
            cloudKitty.stopAnimating()
            AnimationTimer.stop()
            stopped = true
            
            print("left to bed")
            cloudKitty.animationImages = AnimationManager.movingLeftAnimation
            cloudKitty.startAnimating()
            let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
            cloudKitty.goToSleep(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
            AnimationManager.location = .bed
            
            nightOverlay.fadeIn()
            darkOutside.fadeIn()
            lightsOffButton.setBackgroundImage(UIImage(named: "lightson"), for: .normal)
            lightsOffButton.setTitle("  Lights On", for: .normal)
            lightsOffButton.setTitleColor(UIColor.black, for: .normal)
            lightsOff = true
            Sound.startPlaying()
        }
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

