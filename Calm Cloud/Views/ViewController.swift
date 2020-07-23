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
    @IBOutlet weak var outsideBackground: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var recordPlayer: UIImageView!
    
    @IBOutlet weak var boxComingIn: UIImageView!
    @IBOutlet weak var boxInside: UIImageView!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var levelUpImage: UIImageView!
    @IBOutlet weak var levelProgress: UIProgressView!
    
    @IBOutlet weak var receivedPackageContainer: UIView!
    
    @IBOutlet weak var stringLights: UIImageView!
    @IBOutlet weak var insideNightOverlay: UIImageView!
    
    @IBOutlet weak var plusEXPLabel: UILabel!
    @IBOutlet weak var plusEXPLabelAlt: UILabel!
    
    @IBOutlet weak var coinCount: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var tasksView: UIView!
    
    @IBOutlet weak var game: UIImageView!
    
    
    // MARK: Variables
    
    var hasFood = false
    var hasWater = false
    var hasCleanPotty = false
    var hasEaten = false
    var hasDrunk = false
    var hasBeenPet = false
    var isPlaying = false
    var hasPlayed = false
    var summonedToFood = false
    var summonedToWater = false
    var summonedToToy = false
    var summonedToPotty = false
    var inPotty = false
    var stopped = false
    var lightsOff = false
    var playingMusic = false
    var stringLightsOn = false
    var rotated = false
    var summonedToGame = false
    var playingGame = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMoving), name: NSNotification.Name(rawValue: "stopMoving"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnIndoors), name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToSleep), name: NSNotification.Name(rawValue: "goToSleep"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToPotty), name: NSNotification.Name(rawValue: "moveToPotty"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeMiniGame), name: NSNotification.Name(rawValue: "closeMiniGame"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeDelivery), name: NSNotification.Name(rawValue: "closeDelivery"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLevelFromOutside), name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(levelUp), name: NSNotification.Name(rawValue: "levelUp"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMoney), name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeTasks), name: NSNotification.Name(rawValue: "closeTasks"), object: nil)

        openDoor.isHidden = true
        plusEXPLabel.alpha = 0.0
        plusEXPLabelAlt.alpha = 0.0
       
        // load sound
        Sound.loadSound(resourceName: Sounds.inside.resourceName, type: Sounds.inside.type)
        Sound.startPlaying()
        
        loadPhotos()
        loadEntries()
        loadCare()
        loadTasks()
        DataFunctions.loadLevel()
        DataFunctions.loadMoney()
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        AnimationManager.location = .middle
        AnimationManager.movement = .staying
        sleep()
        
        loadUI()
        setMood()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("view will transition")
        rotated = true
        stopMoving()
    }
    
    // MARK: Custom functions
    
    func loadUI() {
        setTimeOfDay()
        
        // set images and exp
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
        
        levelLabel.text = "\(LevelManager.currentLevel)"
        expLabel.text = "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
        var prog: Float = Float(LevelManager.currentEXP) / Float(LevelManager.maxEXP)
        levelProgress.setProgress(prog, animated: true)
        coinCount.text = "\(MoneyManager.total)"
    }
    
    func setTimeOfDay() {
        // change background if night
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour > 6 && hour < 20 {
            outsideBackground.image = UIImage(named: "outsidebackground")
        } else {
            outsideBackground.image = UIImage(named: "outsidebackgroudnight")
        }
    }
    
    func showLevelUp() {
        // display level up image
        view.bringSubviewToFront(levelUpImage)
        levelUpImage.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.view.sendSubviewToBack(self.levelUpImage)
        }
    }
    
    func showEXP(near: UIImageView, exp: Int) {
        // add label feedback to activities that produce exp, near relevant image
        
        // choose whichever label is currently not visible
        if plusEXPLabel.alpha == 0.0 {
            plusEXPLabel.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabel.text = "+\(exp) EXP"
            plusEXPLabel.alpha = 1.0
            plusEXPLabel.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                self.plusEXPLabel.fadeOut()
            }
        } else if plusEXPLabelAlt.alpha == 0.0 {
            plusEXPLabelAlt.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabelAlt.text = "+\(exp) EXP"
            plusEXPLabelAlt.alpha = 1.0
            plusEXPLabelAlt.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                self.plusEXPLabelAlt.fadeOut()
            }
        }
    }
    
    func updateEXP(with amount: Int) {
        // update ui with level info and save
        LevelManager.currentEXP += amount
        
        if LevelManager.currentEXP >= LevelManager.maxEXP {
            LevelManager.currentLevel += 1
            levelLabel.text = "\(LevelManager.currentLevel)"
            LevelManager.calculateLevel()
            showLevelUp()
            levelLabel.animateBounce()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self.receivePackage()
            }
        }
        
        expLabel.text = "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
        var prog: Float = Float(LevelManager.currentEXP) / Float(LevelManager.maxEXP)
        levelProgress.setProgress(prog, animated: true)
        DataFunctions.saveLevel()
    }
    
    @objc func updateMoney() {
        coinCount.text = "\(MoneyManager.total)"
        coinImage.animateBounce()
        
        // resave money
        DataFunctions.saveMoney()
    }
    
    @objc func updateLevelFromOutside() {
        // refresh these level labels when exp is gained outside
        levelLabel.text = "\(LevelManager.currentLevel)"
        expLabel.text = "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
        var prog: Float = Float(LevelManager.currentEXP) / Float(LevelManager.maxEXP)
        levelProgress.setProgress(prog, animated: true)
    }
    
    @objc func levelUp() {
        // show package received from level up
        boxInside.isHidden = false
    }
    
    @objc func returnIndoors() {
        // hide open door and restart animation when returning indoors
        Sound.stopPlaying()
        Sound.loadSound(resourceName: Sounds.inside.resourceName, type: Sounds.inside.type)
        Sound.startPlaying()
        
        setTimeOfDay()
        door.isHidden = false
        openDoor.isHidden = true
        stopped = false
        randomMove()
    }
    
    @objc func goToSleep() {
        // activate sleep animation (called from AnimationExtensions)
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
    }
    
    @objc func moveToPotty() {
        inPotty = true
        // dig while in potty
        dig()
    }
    
    @objc func closeMiniGame() {
        // close mini game container when user dismisses
        view.sendSubviewToBack(containerView)
        stopped = false
        stopMoving()
    }
    
    @objc func closeTasks() {
        // close tasks container when user dismisses
        view.sendSubviewToBack(tasksView)
    }

    @objc func closeDelivery() {
        // close delivery container when user dismisses
        view.sendSubviewToBack(receivedPackageContainer)
        boxInside.isHidden = true
        boxInside.image = UIImage(named: "closedbox")
    }
    
    func randomRepeatCount() -> Int {
        // randomly generate a repeat count for animations
        var randomRepeatCount = Int.random(in: 4...8)
        return randomRepeatCount
    }
    
    func setMood() {
        // set cloud kitty's mood deepending on activities
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
    
    // location change animations, randomized
    
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
            case .game:
                moveRightToPotty()
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
            case .game:
                moveRightToCenter()
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
            case .game:
               moveRightToFood()
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
            case .game:
                moveRightToWater()
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
        // if summoned to location by user tap and conditions are met, execute action
        if summonedToToy && AnimationManager.location != .toy && hasPlayed == false {
            moveRightToToy()
        } else if summonedToGame && AnimationManager.location != .game && hasPlayed == false {
            moveLeftToGame()
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
            case .game:
                moveRightToWater()
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
            case .game:
                moveRightToFood()
            }
        } else if summonedToPotty && hasCleanPotty {
            moveRightToPotty()
        } else {
            randomMove()
        }
    }
    
    @objc func stopMoving() {
        // current animation stopped, randomize next
        print("stop moving called")
        let range = [1,2,3,4]
        let animation = range.randomElement()
        cloudKitty.stopAnimating()
        
        if stopped {
            return
        }
        
        if rotated {
            AnimationTimer.stop()
            rotated = false
        }
        
        if toyImage.isAnimating {
            toyImage.stopAnimating()
        }
        
        if playingGame {
            playingGame = false
        }
         
        if game.isAnimating {
            game.stopAnimating()
        }
        
        if isPlaying {
            isPlaying = false
        }
        
        if inPotty {
            inPotty = false
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
            case .game:
                randomGameAnimation()
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
                print("pet")
                AnimationTimer.stop()
                cloudKitty.stopAnimating()
                cloudKitty.animationImages = AnimationManager.petAnimation
                cloudKitty.animationDuration = 1.0
                cloudKitty.startAnimating()
                hasBeenPet = true
                // add EXP?
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if lightsOff {
                // if petting while lights are off, go back to sleep
                goToSleep()
            } else {
                stopMoving()
            }
        }
    }
    
    @IBAction func lightsOnOff(_ sender: UIButton) {
        if stringLightsOn {
            stringLights.image = UIImage(named: "lights")
            stringLightsOn = false
            
            if lightsOff {
                insideNightOverlay.image = UIImage(named: "nightoverlay")
            }
        } else {
            stringLights.image = UIImage(named: "lightsglow")
            stringLightsOn = true
            
            if lightsOff {
                insideNightOverlay.image = UIImage(named: "glowstars")
            }
        }
    }
    
    @IBAction func recordPlayerTapped(_ sender: UITapGestureRecognizer) {
        if playingMusic {
            recordPlayer.stopAnimating()
            playingMusic = false
            // remove music and turn on ambient sound
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.inside.resourceName, type: Sounds.inside.type)
            Sound.startPlaying()
        } else {
            playingMusic = true
            recordPlayer.animationImages = [UIImage(named: "recordplay1")!, UIImage(named: "recordplay2")!]
            recordPlayer.animationDuration = 2.0
            recordPlayer.animationRepeatCount = 0
            recordPlayer.startAnimating()
            // remove ambient sound and turn on music
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.music.resourceName, type: Sounds.music.type)
            Sound.startPlaying()
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
            updateEXP(with: 5)
            showEXP(near: waterImage, exp: 5)
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
            updateEXP(with: 5)
            showEXP(near: foodImage, exp: 5)
        }
    }
    
    @IBAction func tapOnToy(_ sender: UITapGestureRecognizer) {
        summonedToToy = true
        if isPlaying {
            // do nothing, cat is playing with toy already
        } else {
            toyImage.animationImages = AnimationManager.toyAnimation
            toyImage.animationDuration = 0.3
            toyImage.animationRepeatCount = 2
            toyImage.startAnimating()
        }
    }
    
    @IBAction func cleanPotty(_ sender: UITapGestureRecognizer) {
        summonedToPotty = true

        if hasCleanPotty {
            // do nothing
        } else {
            hasCleanPotty = true
            pottyBox.image = UIImage(named: "litterbox")
            saveCare(food: nil, water: nil, potty: Date())
            setMood()
            updateEXP(with: 10)
            showEXP(near: pottyBox, exp: 10)
        }
    }
    
    @IBAction func doorTapped(_ sender: UITapGestureRecognizer) {
        // go outside
        door.isHidden = true
        openDoor.isHidden = false
        AnimationTimer.stop()
        stopped = true
        performSegue(withIdentifier: "goOutside", sender: Any?.self)
    }
    
    @IBAction func miniGameTapped(_ sender: UIButton) {
        // show mini game
        cloudKitty.stopAnimating()
        AnimationTimer.stop()
        stopped = true
        view.bringSubviewToFront(containerView)
        containerView.animateBounce()
    }
    
    @IBAction func lightsOffTapped(_ sender: UIButton) {
        if lightsOff {
            // if lights are currently off, remove dark layers and return to normal
            darkOutside.fadeOut()
            insideNightOverlay.fadeOut()
            nightOverlay.fadeOut()
            lightsOffButton.setBackgroundImage(UIImage(named: "lightsoff"), for: .normal)
            lightsOffButton.setTitle("  Lights Off", for: .normal)
            lightsOffButton.setTitleColor(UIColor.white, for: .normal)
            lightsOff = false
            stopped = false
            
            // turn off soothing night sounds and return to previous sound
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.inside.resourceName, type: Sounds.inside.type)
            Sound.startPlaying()
            
            stopMoving()
        } else {
            // if lights are currently on, activate dark layers and send kitty to sleep
            cloudKitty.stopAnimating()
            AnimationTimer.stop()
            stopped = true
            stopMoving()
            
            // if cloud kitty is not on bed, move over to it
            if AnimationManager.location != .bed {
                print("left to bed")
                cloudKitty.animationImages = AnimationManager.movingLeftAnimation
                cloudKitty.startAnimating()
                let bedDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/2)
                cloudKitty.goToSleep(to: bedDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
                AnimationManager.location = .bed
            } else {
                goToSleep()
            }
            
            if stringLightsOn {
                insideNightOverlay.image = UIImage(named: "glowstars")
            } else {
                insideNightOverlay.image = UIImage(named: "nightoverlay")
            }
            
            nightOverlay.fadeIn()
            insideNightOverlay.fadeIn()
            darkOutside.fadeIn()
            lightsOffButton.setBackgroundImage(UIImage(named: "lightson"), for: .normal)
            lightsOffButton.setTitle("  Lights On", for: .normal)
            lightsOffButton.setTitleColor(UIColor.black, for: .normal)
            lightsOff = true
            
            // remove previous sound and turn on soothing night sounds
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.night.resourceName, type: Sounds.night.type)
            Sound.startPlaying()
        }
    }
    
    @IBAction func gameTapped(_ sender: UITapGestureRecognizer) {
        summonedToGame = true
        if playingGame {
            // do nothing, cat is playing with game already
        } else {
            game.animationImages = AnimationManager.gameAnimation
            game.animationDuration = 0.3
            game.animationRepeatCount = 1
            game.startAnimating()
        }
    }
    
    @IBAction func boxTapped(_ sender: UITapGestureRecognizer) {
        // open package for more seedlings
        boxInside.image = UIImage(named: "openedbox")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            // show message with received seedlings
            self.view.bringSubviewToFront(self.receivedPackageContainer)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDelivery"), object: nil)
            self.receivedPackageContainer.animateBounce()
        }
    }
    
    @IBAction func toDoTapped(_ sender: UIButton) {
        view.bringSubviewToFront(tasksView)
        tasksView.animateBounce()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTasks"), object: nil)
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

