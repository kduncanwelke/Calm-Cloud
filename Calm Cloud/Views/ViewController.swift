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
    @IBOutlet weak var unlockNotice: UIButton!
    
    @IBOutlet weak var weather: UIImageView!
    @IBOutlet weak var fireplace: UIImageView!
    
    // MARK: Variables

    private let viewModel = ViewModel()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateExperience), name: NSNotification.Name(rawValue: "updateExperience"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeTasks), name: NSNotification.Name(rawValue: "closeTasks"), object: nil)

        openDoor.isHidden = true
        plusEXPLabel.alpha = 0.0
        plusEXPLabelAlt.alpha = 0.0
        weather.isHidden = true

        viewModel.setInside()
        viewModel.loadPhotos()
        viewModel.loadEntries()
        viewModel.loadCare()
        viewModel.loadTasks()
        viewModel.performDataLoads()
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        AnimationManager.location = .middle
        AnimationManager.movement = .staying
        sleep()

        viewModel.weather()

        loadUI()
        viewModel.setMood()
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
        if self.isViewLoaded && (self.view.window != nil) {
            print("view will transition inside")
            cloudKitty.stopAnimating()
            viewModel.stopTimer()
            randomMove()
        }
    }
    
    // MARK: Custom functions
    
    func stopAnimations() {
        cloudKitty.stopAnimating()
        viewModel.stopTimer()
        
        viewModel.stop()
        
        if viewModel.isPlaying() {
            toyImage.stopAnimating()
            viewModel.stopPlaying()
        }
        
        if viewModel.isPlayingGame() {
            game.stopAnimating()
            viewModel.stopPlayingGame()
        }
    }
    
    func loadUI() {
        viewModel.setAmbientSound()
        var result = viewModel.configureWeather()

        outsideBackground.image = result.image

        switch result.condition {
        case .rain:
            weather.isHidden = false
            startRain()
        case .snow:
            weather.isHidden = false
            startSnow()
        case .nothing:
            weather.isHidden = true
        }
        
        // set images and exp
        if viewModel.hasFood() {
            foodImage.isHidden = false
        } else {
            foodImage.isHidden = true
        }
        
        if viewModel.hasWater() {
            waterImage.isHidden = false
        } else {
            waterImage.isHidden = true
        }
        
        if viewModel.hasCleanPotty() {
            pottyBox.image = UIImage(named: "litterbox")
        }

        fireplace.image = viewModel.setFireAppearance()
        updateLevel()
        coinCount.text = viewModel.getCoins()
    }

    func updateCat(activity: Behavior) {
        viewModel.respondToActivity(activity: activity)
    }

    func updateLevel() {
        levelLabel.text = viewModel.getLevel()
        expLabel.text = viewModel.getLevelDetails()
        var prog = viewModel.getProgress()
        levelProgress.setProgress(prog, animated: true)
    }

    func startRain() {
        // raining animation
        weather.animationImages = WeatherManager.rainImages
        weather.animationDuration = 0.3
        weather.startAnimating()
    }

    func startSnow() {
        // add snowing animation
        weather.animationImages = WeatherManager.snowImages
        weather.animationDuration = 2.8
        weather.startAnimating()
    }
    
    func showLevelUp() {
        // display level up image
        view.bringSubviewToFront(levelUpImage)
        levelUpImage.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            if let levelUp = self?.levelUpImage {
                self?.view.sendSubviewToBack(levelUp)
            }
        }
    }
    
    func showEXP(near: UIImageView, exp: Int) {
        // add label feedback to activities that produce exp, near relevant image
        
        // choose whichever label is currently not visible
        if plusEXPLabel.alpha == 0.0 || plusEXPLabel.alpha < plusEXPLabelAlt.alpha {
            plusEXPLabel.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabel.text = "+\(exp) EXP"
            plusEXPLabel.alpha = 1.0
            plusEXPLabel.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.plusEXPLabel.fadeOut()
            }
        } else {
            plusEXPLabelAlt.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabelAlt.text = "+\(exp) EXP"
            plusEXPLabelAlt.alpha = 1.0
            plusEXPLabelAlt.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.plusEXPLabelAlt.fadeOut()
            }
        }
    }
    
    func updateEXP(source: EXPSource) {
        // update ui with level info and save
        if viewModel.updateEXP(source: source) {
            levelLabel.text = viewModel.getLevel()
            showLevelUp()
            levelLabel.animateBounce()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self.receivePackage()
            }
        }
        
       updateLevel()
    }
    
    @objc func updateMoney() {
        // resave money
        viewModel.saveMoney()

        coinCount.text = viewModel.getCoins()
        coinImage.animateBounce()
    }
    
    @objc func updateExperience() {
        // update exp from tasks reward
        updateEXP(source: .reward)
    }
    
    @objc func updateLevelFromOutside() {
        // refresh these level labels when exp is gained outside
        updateLevel()
    }
    
    @objc func levelUp() {
        // show package received from level up
        boxInside.isHidden = false
    }
    
    @objc func returnIndoors() {
        // hide open door and restart animation when returning indoors
        viewModel.setInside()
        viewModel.unStop()

        fireplace.image = viewModel.setFireAppearance()
        
        // restart fire sound if on
        if viewModel.isBurning() {
            viewModel.startCrackle()
        }
        
        // set indoor sound
        viewModel.setAmbientSound()
        
        door.isHidden = false
        openDoor.isHidden = true
        
        stopMoving()
    }
    
    @objc func goToSleep() {
        // activate sleep animation (called from AnimationExtensions)
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
    }
    
    @objc func moveToPotty() {
        viewModel.inPotty()
        // dig while in potty
        dig()
    }
    
    @objc func closeMiniGame() {
        // close mini game container when user dismisses
        view.sendSubviewToBack(containerView)
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
    
    // location change animations, randomized
    
    func randomMove() {
        print("randommove")
        var animate = viewModel.randomMovementAnimation()
        doAnimation(animate: animate)
        viewModel.updateLocation(movement: animate)
    }
    
    @objc func stopMoving() {
        if viewModel.getScreen() == .inside {
            print("indoor view on screen")
            // current animation stopped, randomize next
            print("stop moving called")
           
            cloudKitty.stopAnimating()
            
            if viewModel.isStopped() {
                if viewModel.lightsOff() {
                    goNightNight()
                }
                return
            }

            viewModel.performAnimationResets(toy: toyImage, game: game)
            
            var animate = viewModel.randomizeAnimationType()

            doAnimation(animate: animate)

            viewModel.updateLocation(movement: animate)
        }
    }

    func doAnimation(animate: Animation) {
        // switch on animation type
        switch animate {
        case .bounce:
            bounce()
        case .drink:
            drink()
        case .eat:
            eat()
        case .floatLeft:
            floatLeft()
        case .floatRight:
            floatRight()
        case .floatSleep:
            floatSleep()
        case .floatUp:
            floatUp()
        case .linger:
            linger()
        case .moveIntoPotty:
            moveIntoPotty()
        case .moveLeftToBed:
            moveLeftToBed()
        case .moveLeftToCenter:
            moveLeftToCenter()
        case .moveLeftToFood:
            moveLeftToFood()
        case .moveLeftToGame:
            moveLeftToGame()
        case .moveLeftToPotty:
            moveLeftToPotty()
        case .moveLeftToToy:
            moveLeftToToy()
        case .moveLeftToWater:
            moveLeftToWater()
        case .moveRightToCenter:
            moveRightToCenter()
        case .moveRightToFood:
            moveRightToFood()
        case .moveRightToPillow:
            moveRightToPillow()
        case .moveRightToPotty:
            moveRightToPotty()
        case .moveRightToToy:
            moveRightToToy()
        case .moveRightToWater:
            moveRightToWater()
        case .pause:
            pause()
        case .play:
            play()
        case .playGame:
            playGame()
        case .sleep:
            sleep()
        }
    }
    
    // MARK: IBActions

    @IBAction func catTouched(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if AnimationManager.movement == .staying {
                print("pet")
                viewModel.stopTimer()
                cloudKitty.stopAnimating()
                cloudKitty.animationImages = AnimationManager.petAnimation
                cloudKitty.animationDuration = 1.0
                cloudKitty.startAnimating()
                viewModel.petted()
                // add EXP?
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if viewModel.lightsOff() {
                // if petting while lights are off, go back to sleep
                goToSleep()
            } else {
                sleep()
            }
        }
    }
    
    @IBAction func lightsOnOff(_ sender: UIButton) {
        if viewModel.canAccessLights() {
            if viewModel.stringLightsOn() {
                viewModel.turnStringLightsOff()
            } else {
                viewModel.turnStringLightsOn()
            }

            var images = viewModel.configureLights()
            
            stringLights.image = images.lights
            insideNightOverlay.image = images.overlay
        } else {
            unlockNotice.setTitle("Unlocks at level \(LevelManager.lightsUnlock)", for: .normal)
            unlockNotice.animateFadeInSlow()
        }
    }
    
    @IBAction func recordPlayerTapped(_ sender: UITapGestureRecognizer) {
        if viewModel.lightsOff() {
            // don't turn on music with lights off
            return
        } else {
            if viewModel.canAccessRecordPlayer() {
                if viewModel.musicOn() {
                    recordPlayer.stopAnimating()
                    viewModel.stopMusic()

                    // remove music and turn on ambient sound
                    Sound.stopPlaying()
                    viewModel.setAmbientSound()
                } else {
                    viewModel.startMusic()
                    recordPlayer.animationImages = [UIImage(named: "recordplay1")!, UIImage(named: "recordplay2")!]
                    recordPlayer.animationDuration = 2.0
                    recordPlayer.animationRepeatCount = 0
                    recordPlayer.startAnimating()

                    // remove ambient sound and turn on music
                    Sound.stopPlaying()
                    Sound.loadSound(resourceName: Sounds.music.resourceName, type: Sounds.music.type)
                    Sound.startPlaying()
                }
            } else {
                unlockNotice.setTitle("Unlocks at level \(LevelManager.playerUnlock)", for: .normal)
                unlockNotice.animateFadeInSlow()
            }
        }
    }
    
    @IBAction func giveWater(_ sender: UITapGestureRecognizer) {
        viewModel.waterSummon()
        
        if viewModel.hasWater() {
            // do nothing
        } else {
            waterImage.isHidden = false
            viewModel.giveWater()
            viewModel.saveCare(food: nil, water: Date(), potty: nil)
            updateEXP(source: .water)
            showEXP(near: waterImage, exp: 5)
        }
    }
    
    @IBAction func giveFood(_ sender: UITapGestureRecognizer) {
        viewModel.foodSummon()
        
        if viewModel.hasFood() {
            // do nothing
        } else {
            foodImage.isHidden = false
            viewModel.giveFood()
            viewModel.saveCare(food: Date(), water: nil, potty: nil)
            updateEXP(source: .food)
            showEXP(near: foodImage, exp: 5)
        }
    }
    
    @IBAction func tapOnToy(_ sender: UITapGestureRecognizer) {
        viewModel.toySummon()
        
        if viewModel.isPlaying() {
            // do nothing, cat is playing with toy already
        } else {
            toyImage.animationImages = AnimationManager.toyAnimation
            toyImage.animationDuration = 0.3
            toyImage.animationRepeatCount = 2
            toyImage.startAnimating()
        }
    }
    
    @IBAction func cleanPotty(_ sender: UITapGestureRecognizer) {
        viewModel.pottySummon()

        if viewModel.hasCleanPotty() {
            // do nothing
        } else {
            viewModel.cleanPotty()
            pottyBox.image = UIImage(named: "litterbox")
            viewModel.saveCare(food: nil, water: nil, potty: Date())
            viewModel.setMood()
            updateEXP(source: .potty)
            showEXP(near: pottyBox, exp: 10)
        }
    }
    
    @IBAction func doorTapped(_ sender: UITapGestureRecognizer) {
        // go outside
        viewModel.setOutside()
        door.isHidden = true
        openDoor.isHidden = false
        FireSound.stopPlaying()
        stopAnimations()
        performSegue(withIdentifier: "goOutside", sender: Any?.self)
    }
    
    @IBAction func miniGameTapped(_ sender: UIButton) {
        /*if viewModel.lightsOff() {
            // don't allow mini game when lights are off
            return
        } else {
            // show mini game
            view.bringSubviewToFront(containerView)
            containerView.animateBounce()
        }*/

        performSegue(withIdentifier: "goToGame", sender: Any?.self)
    }
    
    @IBAction func lightsOffTapped(_ sender: UIButton) {
        if viewModel.lightsOff() {
            // if lights are currently off, remove dark layers and return to normal
            darkOutside.fadeOut()
            insideNightOverlay.fadeOut()
            nightOverlay.fadeOut()
            lightsOffButton.setBackgroundImage(UIImage(named: "lightsoff"), for: .normal)
            lightsOffButton.setTitle("  Lights Off", for: .normal)
            lightsOffButton.setTitleColor(UIColor.white, for: .normal)

            viewModel.turnLightsOn()
            viewModel.unStop()

            // turn off soothing night sounds and return to previous sound
            Sound.stopPlaying()
            viewModel.setAmbientSound()
            
            stopMoving()
        } else {
            // if lights are currently on, activate dark layers and send kitty to sleep
            viewModel.stop()
            viewModel.turnLightsOff()
            
            if AnimationManager.movement == .staying {
                cloudKitty.stopAnimating()
                AnimationTimer.stop()
                
                // if cloud kitty is not on bed, move over to it
                if viewModel.getAnimationLocation() != .bed {
                    goNightNight()
                } else {
                    goToSleep()
                }
            }
            
            insideNightOverlay.image = viewModel.configureLights().overlay
            stringLights.image = viewModel.configureLights().lights

            // if music was playing, it will stop so turn off record player
            recordPlayer.stopAnimating()
            viewModel.stopMusic()
            
            nightOverlay.fadeIn()
            insideNightOverlay.fadeIn()
            darkOutside.fadeIn()
            lightsOffButton.setBackgroundImage(UIImage(named: "lightson"), for: .normal)
            lightsOffButton.setTitle("  Lights On", for: .normal)
            lightsOffButton.setTitleColor(UIColor.black, for: .normal)
            
            // remove previous sound and turn on soothing night sounds
            Sound.stopPlaying()
            viewModel.setAmbientSound()
        }
    }
    
    @IBAction func gameTapped(_ sender: UITapGestureRecognizer) {
        viewModel.gameSummon()
        if viewModel.isPlayingGame() {
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
    
    @IBAction func fireplaceTapped(_ sender: UITapGestureRecognizer) {
        viewModel.fireSummon()
        
        if viewModel.fireHasFuel() {
            if viewModel.isBurning() {
                FireSound.stopPlaying()
                viewModel.turnOffFire()
                fireplace.stopAnimating()

                insideNightOverlay.image = viewModel.configureLights().overlay
            } else {
                FireSound.loadSound(resourceName: Sounds.fire.resourceName, type: Sounds.fire.type)
                FireSound.startPlaying()
                viewModel.turnOnFire()
               
                if viewModel.fireHasSparkles() {
                    fireplace.animationImages = AnimationManager.fireAnimationColor
                } else {
                    fireplace.animationImages = AnimationManager.fireAnimation
                }
                
                fireplace.animationDuration = 0.8
                fireplace.startAnimating()
                
                insideNightOverlay.image = viewModel.configureLights().overlay
            }
        } else {
            unlockNotice.setTitle("Requires wood!", for: .normal)
            unlockNotice.animateFadeInSlow()
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

