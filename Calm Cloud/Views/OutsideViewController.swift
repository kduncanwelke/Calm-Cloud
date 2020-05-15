//
//  OutsideViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class OutsideViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cloudKitty: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var inventoryContainer: UIView!
    
    @IBOutlet weak var fencePlot1: UIImageView!
    @IBOutlet weak var fencePlot2: UIImageView!
    @IBOutlet weak var fencePlot3: UIImageView!
    @IBOutlet weak var fencePlot4: UIImageView!
    @IBOutlet weak var fencePlot5: UIImageView!
    @IBOutlet weak var fencePlot6: UIImageView!
    
    @IBOutlet weak var vegetablePlot1: UIImageView!
    @IBOutlet weak var vegetablePlot2: UIImageView!
    @IBOutlet weak var vegetablePlot3: UIImageView!
    @IBOutlet weak var vegetablePlot4: UIImageView!
    @IBOutlet weak var vegetablePlot5: UIImageView!
    @IBOutlet weak var vegetablePlot6: UIImageView!
    
    @IBOutlet weak var planterPlot1: UIImageView!
    @IBOutlet weak var planterPlot2: UIImageView!
    @IBOutlet weak var planterPlot3: UIImageView!
    
    @IBOutlet weak var frontPlot1: UIImageView!
    @IBOutlet weak var frontPlot2: UIImageView!
    @IBOutlet weak var frontPlot3: UIImageView!
    @IBOutlet weak var frontPlot4: UIImageView!
    @IBOutlet weak var frontPlot5: UIImageView!
    @IBOutlet weak var frontPlot6: UIImageView!
    @IBOutlet weak var frontPlot7: UIImageView!
    @IBOutlet weak var frontPlot8: UIImageView!
    
    @IBOutlet weak var succulentPot1: UIImageView!
    @IBOutlet weak var succulentPot2: UIImageView!
    @IBOutlet weak var succulentPot3: UIImageView!
    
    @IBOutlet weak var tallPotPlot: UIImageView!
    @IBOutlet weak var smallPotPlot: UIImageView!
    
    
    
    // MARK: Variables
    
    var selectedPlot = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMovingOutside), name: NSNotification.Name(rawValue: "stopMovingOutside"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closePopUp), name: NSNotification.Name(rawValue: "closePopUp"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInventory), name: NSNotification.Name(rawValue: "showInventory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeInventory), name: NSNotification.Name(rawValue: "closeInventory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(plant), name: NSNotification.Name(rawValue: "plant"), object: nil)
        
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        AnimationManager.outsideLocation = .back
        sleep()
        
        loadPlots()
    }
    
    // MARK: Custom functions
    
    @objc func closePopUp() {
        view.sendSubviewToBack(messageContainer)
    }
    
    @objc func showInventory() {
        view.sendSubviewToBack(messageContainer)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        view.bringSubviewToFront(inventoryContainer)
    }
    
    @objc func closeInventory() {
        view.sendSubviewToBack(inventoryContainer)
    }
    
    @objc func plant() {
        // change based on selected species
        savePlanting(id: selectedPlot, plant: PlantManager.selected.rawValue)
        
        if selectedPlot == 1 {
            fencePlot1.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 2 {
            fencePlot2.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 3 {
            fencePlot3.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 4 {
            fencePlot4.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 5 {
            fencePlot5.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 6 {
            fencePlot6.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 7 {
            frontPlot1.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 8 {
            frontPlot2.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 9 {
            frontPlot3.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 10 {
            frontPlot4.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 11 {
            frontPlot5.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 12 {
            frontPlot6.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 13 {
            frontPlot7.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 14 {
            frontPlot8.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 15 {
            succulentPot1.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 16 {
            succulentPot2.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 17 {
            succulentPot3.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 18 {
            planterPlot1.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 19 {
            planterPlot2.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 20 {
            planterPlot3.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 21 {
            tallPotPlot.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 22 {
            vegetablePlot1.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 23 {
            vegetablePlot2.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 24 {
            vegetablePlot3.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 25 {
            vegetablePlot4.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 26 {
            vegetablePlot5.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 27 {
            vegetablePlot6.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        } else if selectedPlot == 28 {
            smallPotPlot.image = PlantManager.getStage(date: Date(), plant: PlantManager.selected)
        }
        
        view.sendSubviewToBack(inventoryContainer)
    }
    
    func tappedPlant(image: UIImageView) {
        if image.image?.pngData() == UIImage(named: "emptyplot")?.pngData() || image.image?.pngData() == UIImage(named: "emptyplotbig")?.pngData() || image.image?.pngData() == UIImage(named: "emptyplottree")?.pngData() || image.image?.pngData() == UIImage(named: "emptyplotsmallpot")?.pngData() {
            if selectedPlot < 15 {
                PlantManager.area = .flowerStrips
                print("flower strip")
            } else if selectedPlot > 14 && selectedPlot < 18 {
                PlantManager.area = .lowPot
                print("bowl")
            } else if selectedPlot > 17 && selectedPlot < 21 {
                PlantManager.area = .planter
                print("planter")
            } else if selectedPlot == 21 {
                PlantManager.area = .tallPot
                print("tall pot")
            } else if selectedPlot == 28 {
                PlantManager.area = .smallPot
                print("small pot")
            } else {
                PlantManager.area = .vegetablePlot
                print("vegetable plot")
            }
            
            view.bringSubviewToFront(messageContainer)
        }
    }
    
    func randomRepeatCount() -> Int {
        var randomRepeatCount = Int.random(in: 4...8)
        return randomRepeatCount
    }
    
    func floatUp() {
        print("float")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/2, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .ceiling
    }
    
    // left movement
    
    func floatLeft() {
        print("float left")
        cloudKitty.animationImages = AnimationManager.upsideDownLeft
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/8, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .ceiling
    }
    
    func moveLeftToBack() {
        print("left to back")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .back
    }
    
    func moveLeftToPlanter() {
        print("left to planter")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let planterDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2)
        cloudKitty.outsideMove(to: planterDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .planter
    }
    
    func moveLeftToWidePot() {
        print("left to wide pot")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let potDestination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .pot
    }
    
    func moveLeftToCenter() {
        print("left to center")
        cloudKitty.animationImages = AnimationManager.movingLeftAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .front
    }
    
    // right movement
    
    func floatRight() {
        print("float right")
        cloudKitty.animationImages = AnimationManager.upsideDownRight
        cloudKitty.startAnimating()
        let ceilingDestination = CGPoint(x: container.frame.width/1.12, y: container.frame.height/6)
        cloudKitty.outsideMove(to: ceilingDestination, duration: 4.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .ceiling
    }
    
    func moveRightToBack() {
        print("right to back")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .back
    }
    
    func moveRightToGate() {
        print("right to gate")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let gateDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*1.5)
        cloudKitty.outsideMove(to: gateDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .gate
    }
    
    func moveRightToCenter() {
        print("right to center")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let centerDestination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        cloudKitty.outsideMove(to: centerDestination, duration: 2, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .front
    }
    
    func moveRightToPots() {
        print("right to pots")
        cloudKitty.animationImages = AnimationManager.movingRightAnimation
        cloudKitty.startAnimating()
        let potsDestination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2.4)
        cloudKitty.outsideMove(to: potsDestination, duration: 3.0, options: UIView.AnimationOptions.curveEaseOut)
        AnimationManager.outsideLocation = .pots
    }
    
    // sleep animations
    
    func sleep() {
        print("sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func floatSleep() {
        print("float sleep")
        cloudKitty.animationImages = AnimationManager.sleepAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.animationRepeatCount = 0
        cloudKitty.startAnimating()
        let destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY)
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMoveOutside(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }

    // place non-specific animations
    
    func bounce() {
        print("bounce")
        cloudKitty.animationImages = AnimationManager.bouncingAnimation
        cloudKitty.animationDuration = 2.0
        cloudKitty.startAnimating()
        
        let destination: CGPoint
        
        switch AnimationManager.outsideLocation {
        case .ceiling:
            destination = CGPoint(x: cloudKitty.frame.midX, y: cloudKitty.frame.midY) //CGPoint(x: container.frame.width/2, y: container.frame.height/1.2)
        case .back:
            destination = CGPoint(x: container.frame.width/2, y: (container.frame.height/3)*1.52)
        case .front:
            destination = CGPoint(x: container.frame.width/3, y: (container.frame.height/3)*2.35)
        case .gate:
            destination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*1.5)
        case .planter:
            destination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2)
        case .pot:
            destination = CGPoint(x: container.frame.width/4, y: (container.frame.height/3)*2.4)
        case .pots:
            destination = CGPoint(x: container.frame.width/1.18, y: (container.frame.height/3)*2.4)
        }
        
        let floatDestination = CGPoint(x: destination.x, y: destination.y-20)
        cloudKitty.floatMoveOutside(to: floatDestination, returnTo: destination, duration: 2.0, options: [UIView.AnimationOptions.curveLinear])
    }
    
    func pause() {
        cloudKitty.image = AnimationManager.startImage
        AnimationTimer.beginTimer(repeatCount: randomRepeatCount())
    }
    
    func randomBackAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
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
    
    func randomFrontAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomGateAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomPlanterAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomPotAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomPotsAnimation() {
        let range = [1,2]
        let animation = range.randomElement()
        
        if animation == 1 {
            bounce()
        } else {
            pause()
        }
    }
    
    func randomMove() {
        let range = [1,2,3,4]
        let animation = range.randomElement()
        
        if animation == 1 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveRightToGate()
            case .ceiling:
                moveLeftToPlanter()
            case .front:
                moveRightToBack()
            case .gate:
                moveLeftToPlanter()
            case .planter:
                moveRightToBack()
            case .pot:
                moveRightToCenter()
            case .pots:
                moveLeftToBack()
            }
        } else if animation == 2 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveLeftToCenter()
            case .ceiling:
                moveRightToBack()
            case .front:
                moveLeftToPlanter()
            case .gate:
                moveLeftToCenter()
            case .planter:
                moveRightToGate()
            case .pot:
                moveRightToBack()
            case .pots:
                moveRightToCenter()
            }
        } else if animation == 3 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveLeftToWidePot()
            case .ceiling:
                moveRightToGate()
            case .front:
                moveLeftToWidePot()
            case .gate:
                moveLeftToWidePot()
            case .planter:
                moveRightToCenter()
            case .pot:
                moveRightToCenter()
            case .pots:
                moveLeftToBack()
            }
        } else if animation == 4 {
            switch AnimationManager.outsideLocation {
            case .back:
                moveLeftToPlanter()
            case .ceiling:
                moveLeftToCenter()
            case .front:
                moveRightToGate()
            case .gate:
                moveLeftToBack()
            case .planter:
                moveLeftToWidePot()
            case .pot:
                moveLeftToPlanter()
            case .pots:
                moveLeftToBack()
            }
        }
    }
    
    @objc func stopMovingOutside() {
        cloudKitty.stopAnimating()
        let range = [1,2,3,4,5]
        let animation = range.randomElement()
        cloudKitty.stopAnimating()
        
        if animation == 1 {
            AnimationManager.movement = .moving
            randomMove()
        } else if animation == 2 {
            AnimationManager.movement = .staying
            switch AnimationManager.outsideLocation {
            case .back:
                randomBackAnimation()
            case .ceiling:
                randomCeilingAnimation()
            case .front:
                randomFrontAnimation()
            case .gate:
                randomGateAnimation()
            case .planter:
                randomPlanterAnimation()
            case .pot:
                randomPotAnimation()
            case .pots:
                randomPotsAnimation()
            }
        } else if animation == 3 {
            switch AnimationManager.outsideLocation {
            case .ceiling:
                floatSleep()
            default:
                sleep()
            }
        } else if animation == 4 {
            AnimationManager.movement = .staying
            print("pause")
            switch AnimationManager.outsideLocation {
            case .ceiling:
                bounce()
            default:
                pause()
            }
        } else {
            if AnimationManager.mood == .happy && AnimationManager.outsideLocation != .ceiling {
                floatUp()
            } else {
                randomMove()
            }
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
    
    @IBAction func inventoryTapped(_ sender: UIButton) {
        PlantManager.area = .none
        view.bringSubviewToFront(inventoryContainer)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @IBAction func fencePlot1Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 1
        tappedPlant(image: fencePlot1)
    }
    
    @IBAction func fencePlot2Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 2
        tappedPlant(image: fencePlot2)
    }
    
    @IBAction func fencePlot3Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 3
        tappedPlant(image: fencePlot3)
    }
    
    @IBAction func fencePlot4Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 4
        tappedPlant(image: fencePlot4)
    }
    
    @IBAction func fencePlot5Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 5
        tappedPlant(image: fencePlot5)
    }
    
    @IBAction func fencePlot6Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 6
        tappedPlant(image: fencePlot6)
    }
    
    @IBAction func frontPlot1Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 7
        tappedPlant(image: frontPlot1)
    }
    
    @IBAction func frontPlot2Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 8
        tappedPlant(image: frontPlot2)
    }
    
    @IBAction func frontPlot3Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 9
        tappedPlant(image: frontPlot3)
    }
    
    @IBAction func frontPlot4Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 10
        tappedPlant(image: frontPlot4)
    }
    
    @IBAction func frontPlot5Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 11
        tappedPlant(image: frontPlot5)
    }
    
    @IBAction func frontPlot6Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 12
        tappedPlant(image: frontPlot6)
    }
    
    @IBAction func frontPlot7Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 13
        tappedPlant(image: frontPlot7)
    }
    
    @IBAction func frontPlot8Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 14
        tappedPlant(image: frontPlot8)
    }
    
    @IBAction func succulentPot1Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 15
        tappedPlant(image: succulentPot1)
    }
    
    @IBAction func succulentPot2Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 16
        tappedPlant(image: succulentPot2)
    }
    
    @IBAction func succulentPot3Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 17
        tappedPlant(image: succulentPot3)
    }
    
    @IBAction func planterPlot1Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 18
        tappedPlant(image: planterPlot1)
    }
    
    @IBAction func planterPlot2Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 19
        tappedPlant(image: planterPlot2)
    }
    
    @IBAction func planterPlot3Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 20
        tappedPlant(image: planterPlot3)
    }
    
    @IBAction func tallPotPlotTapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 21
        tappedPlant(image: tallPotPlot)
    }
    
    @IBAction func vegetablePlot1Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 22
        tappedPlant(image: vegetablePlot1)
    }
    
    @IBAction func vegetablePlot2Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 23
        tappedPlant(image: vegetablePlot2)
    }
    
    @IBAction func vegetablePlot3Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 24
        tappedPlant(image: vegetablePlot3)
    }
    
    @IBAction func vegetablePlot4Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 25
        tappedPlant(image: vegetablePlot4)
    }
    
    @IBAction func vegetablePlot5Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 26
        tappedPlant(image: vegetablePlot5)
    }
    
    @IBAction func vegetablePlot6Tapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 27
        tappedPlant(image: vegetablePlot6)
    }
    
    @IBAction func smallPotPlotTapped(_ sender: UITapGestureRecognizer) {
        selectedPlot = 28
        tappedPlant(image: smallPotPlot)
    }
    
    
    @IBAction func returnPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        cloudKitty.stopAnimating()
        AnimationTimer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
}
