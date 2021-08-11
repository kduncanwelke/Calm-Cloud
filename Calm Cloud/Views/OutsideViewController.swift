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
    @IBOutlet weak var removeContainer: UIView!
    @IBOutlet weak var harvestContainer: UIView!
    @IBOutlet weak var cupsMiniGameContainer: UIView!
    
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
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var levelUpImage: UIImageView!
    @IBOutlet weak var levelProgress: UIProgressView!
    
    @IBOutlet weak var plusEXPLabel: UILabel!
    @IBOutlet weak var plusEXPLabelAlt: UILabel!
    
    @IBOutlet weak var honorStand: UIImageView!
    @IBOutlet var honorStandImages: [UIImageView]!
    @IBOutlet weak var honorStandMoney: UIImageView!
    
    @IBOutlet weak var coinCount: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    
    @IBOutlet weak var earningsView: UIView!
    @IBOutlet weak var earningsMessage: UILabel!
    
    @IBOutlet weak var outsideImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var normalText: UIButton!
    @IBOutlet weak var waterText: UIButton!
    @IBOutlet weak var removeText: UIButton!
    
    @IBOutlet weak var lanterns: UIImageView!
    @IBOutlet weak var unlockNotice: UIButton!
    @IBOutlet weak var plantName: UIButton!
    
    @IBOutlet weak var weather: UIImageView!

    // MARK: Variables

    private let viewModel = ViewModel()
    private let outsideViewModel = OutsideViewModel()

    var tappedImage: UIImageView?
    var rotated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(stopMovingOutside), name: NSNotification.Name(rawValue: "stopMovingOutside"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closePopUp), name: NSNotification.Name(rawValue: "closePopUp"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInventory), name: NSNotification.Name(rawValue: "showInventory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeInventory), name: NSNotification.Name(rawValue: "closeInventory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeHarvestMessage), name: NSNotification.Name(rawValue: "closeHarvestMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(harvestPlant), name: NSNotification.Name(rawValue: "harvestPlant"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(plant), name: NSNotification.Name(rawValue: "plant"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadHonorStand), name: NSNotification.Name(rawValue: "loadHonorStand"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLevelFromBasket), name: NSNotification.Name(rawValue: "updateLevelFromBasket"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeRemoveMessage), name: NSNotification.Name(rawValue: "closeRemoveMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removePlant), name: NSNotification.Name(rawValue: "removePlant"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoins), name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideMiniGame), name: NSNotification.Name(rawValue: "hideMiniGame"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(loadPlants), name: NSNotification.Name(rawValue: "loadPlants"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(waterPlant), name: NSNotification.Name(rawValue: "waterPlant"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(restart), name: NSNotification.Name(rawValue: "restart"), object: nil)
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)

        viewModel.setOutside()
        
        plusEXPLabel.alpha = 0.0
        plusEXPLabelAlt.alpha = 0.0
        honorStandMoney.isHidden = true
        coinCount.text = viewModel.getCoins()
        earningsView.isHidden = true
        
        normalText.alpha = 1.0
        waterText.alpha = 0.0
        removeText.alpha = 0.0
        
        outsideViewModel.setOutsidePosition()
        sleep()
        
        loadUI()
        outsideViewModel.loadInventory()
        outsideViewModel.loadPlots()
       
        checkForPurchases()
        // set mode to default to planting
        outsideViewModel.setMode(button: .planting)
        outsideViewModel.resumeOutside()
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
            print("view will transition outside")
            cloudKitty.stopAnimating()
            viewModel.stopTimer()
            randomMove()
        }
    }
    
    // MARK: Custom functions
    
    func stop() {
        cloudKitty.stopAnimating()
        viewModel.stopTimer()
        outsideViewModel.stopOutside()
    }

    func isStopped() -> Bool {
        return outsideViewModel.isStopped()
    }

    @objc func restart() {
        outsideViewModel.resumeOutside()
        
        stopMovingOutside()
    }

    func loadUI() {
        outsideViewModel.setAmbientSound()

        var result = outsideViewModel.configureWeather()

        outsideImage.image = result.image

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
        
        // update level
        updateLevel()
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
    
    func checkForPurchases() {
        honorStandMoney.isHidden = outsideViewModel.hideMoneyInHonorStand()

        loadHonorStand()
    }
    
    @objc func loadHonorStand() {
        var result = outsideViewModel.configureHonorStand(honorStandImages: honorStandImages)

        honorStandMoney.isHidden = result.hidden
        honorStandImages = result.imagesForHonorStand
    }
    
    @objc func updateLevelFromBasket() {
        // refresh these level labels when exp is gained outside
        levelLabel.text = viewModel.getLevel()
        expLabel.text = viewModel.getLevelDetails()
    }
    
    @objc func updateCoins() {
        coinCount.text = viewModel.getCoins()
        coinImage.animateBounce()
        
        // resave money
        outsideViewModel.saveMoney()
    }
    
    func showEXP(near: UIImageView, exp: Int) {
        // show exp
        // choose whichever label is currently not visible
        if plusEXPLabel.alpha == 0.0 || plusEXPLabel.alpha < plusEXPLabelAlt.alpha {
            print("label one")
            print(plusEXPLabel.alpha)
            plusEXPLabel.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabel.text = "+\(exp) EXP"
            plusEXPLabel.alpha = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.plusEXPLabel.fadeOut()
            }
        } else {
            print("label two")
            plusEXPLabelAlt.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabelAlt.text = "+\(exp) EXP"
            plusEXPLabelAlt.alpha = 1.0
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.plusEXPLabelAlt.fadeOut()
            }
        }
    }
    
    func updateEXP(source: EXPSource) {
        if viewModel.updateEXP(source: source) {
            levelLabel.text = viewModel.getLevel()
            showLevelUp()
            levelLabel.animateBounce()

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "levelUp"), object: nil)
        }

        updateLevel()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
    }
    
    func showLevelUp() {
        // show level up image
        view.bringSubviewToFront(levelUpImage)
        levelUpImage.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            if let image = self?.levelUpImage {
                self?.view.sendSubviewToBack(image)
            }
        }
    }

    @objc func loadPlants() {
        var idList = outsideViewModel.getPlotIDs()

        var i = 0

        for id in idList {
            // update images
            let view = container.subviews.filter { $0.tag == id }.first

            if let imageView = view as? UIImageView {
                imageView.image = outsideViewModel.getStage(plot: outsideViewModel.getPlots(index: i))
            }

            i += 1
        }
    }

    @objc func waterPlant() {
        let view = container.subviews.filter { $0.tag == outsideViewModel.getPlot() }.first
        print("plot \(outsideViewModel.getPlot())")

        if let imageView = view as? UIImageView {
            // show exp feedback
            updateEXP(source: .water)
            showEXP(near: imageView, exp: 5)
        }
    }
    
    @objc func closePopUp() {
        // close message popup
        view.sendSubviewToBack(messageContainer)
    }
    
    @objc func hideMiniGame() {
        view.sendSubviewToBack(cupsMiniGameContainer)
    }
    
    @objc func harvestPlant() {
        // close message popup
        view.sendSubviewToBack(harvestContainer)
        
        // remove plant image and delete save
        outsideViewModel.deletePlanting()
        
        // show exp gain
        if let image = tappedImage {
            showEXP(near: image, exp: 15)
            updateEXP(source: .harvest)
            
            // update image
            image.image = outsideViewModel.removePlant()
        }
      
        print(PlantManager.selected)
        
        outsideViewModel.harvest()
    }
    
    @objc func removePlant() {
        // close message popup
        view.sendSubviewToBack(removeContainer)
        
        // remove plant image and delete save
        outsideViewModel.deletePlanting()
        
        if let image = tappedImage {
            image.image = outsideViewModel.removePlant()
        }
    }
    
    @objc func closeRemoveMessage() {
        // close message popup
        view.sendSubviewToBack(removeContainer)
    }
    
    @objc func closeHarvestMessage() {
        // close message popup
        view.sendSubviewToBack(harvestContainer)
    }
    
    @objc func showInventory() {
        // show seedling inventory
        view.sendSubviewToBack(messageContainer)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        view.bringSubviewToFront(inventoryContainer)
    }
    
    @objc func closeInventory() {
        // close inventory
        view.sendSubviewToBack(inventoryContainer)
    }
    
    @objc func plant() {
        view.sendSubviewToBack(inventoryContainer)
        // change based on selected species
        outsideViewModel.saveInventory()
        outsideViewModel.savePlanting()
        
        var imageToUpdate: UIImageView
        updateEXP(source: .planting)

        let view = container.subviews.filter { $0.tag == outsideViewModel.getPlot() }.first

        if let imageView = view as? UIImageView {
            imageToUpdate = imageView

            // show exp feedback
            showEXP(near: imageToUpdate, exp: 10)
            // update image
            imageToUpdate.image = outsideViewModel.getPlant()
        }
    }

    func tappedPlant(image: UIImageView) {
        tappedImage = image
        outsideViewModel.setPlot(plot: image.tag)
        outsideViewModel.setPlotArea()
        
        if let response = outsideViewModel.handlePlantTap(image: image) {
            switch response {
            case .message:
                view.bringSubviewToFront(messageContainer)
            case .harvest:
                view.bringSubviewToFront(harvestContainer)
            case .water:
                return
            case .identity:
                plantName.setTitle(outsideViewModel.getName(), for: .normal)
                plantName.animateFadeInSlow()
            case .remove:
                view.bringSubviewToFront(removeContainer)
            }
        }
    }

    // MARK: Animation

    func randomMove() {
        var animate = outsideViewModel.randomMovementAnimation()
        doAnimation(animate: animate)
        outsideViewModel.updateLocation(movement: animate)
    }

    @objc func stopMovingOutside() {
        if viewModel.getScreen() == .outside {
            print("outdoor view on screen")
            // run after an animation is complete, randomize next
            cloudKitty.stopAnimating()

            if outsideViewModel.isStopped() {
                return
            }

            var animate = outsideViewModel.randomizeAnimationType()

            doAnimation(animate: animate)

            outsideViewModel.updateLocation(movement: animate)
        }
    }

    func doAnimation(animate: OutsideAnimation) {
        switch animate {
        case .bounce:
            bounce()
        case .floatLeft:
            floatLeft()
        case .floatRight:
            floatRight()
        case .floatSleep:
            floatSleep()
        case .floatUp:
            floatUp()
        case .moveLeftToBack:
            moveLeftToBack()
        case .moveLeftToCenter:
            moveLeftToCenter()
        case .moveLeftToPlanter:
            moveLeftToPlanter()
        case .moveLeftToWidePot:
            moveLeftToWidePot()
        case .moveRightToBack:
            moveRightToBack()
        case .moveRightToCenter:
            moveRightToCenter()
        case .moveRightToGate:
            moveRightToGate()
        case .moveRightToPots:
            moveRightToPots()
        case .pause:
            pause()
        case .sleep:
            sleep()
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
    
    @IBAction func miniGameTapped(_ sender: UIButton) {
        // show mini game
        view.bringSubviewToFront(cupsMiniGameContainer)
        cupsMiniGameContainer.animateBounce()
    }
    
    @IBAction func inventoryTapped(_ sender: UIButton) {
        outsideViewModel.resetArea()
        view.bringSubviewToFront(inventoryContainer)
        inventoryContainer.animateBounce()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @IBAction func onOffPressed(_ sender: UIButton) {
        if outsideViewModel.canAccessLanterns() {
            if outsideViewModel.lanternsOn() {
                outsideViewModel.turnLanternsOff()
                lanterns.image = UIImage(named: "lanternsoff")
            } else {
                outsideViewModel.turnLanternsOn()
                lanterns.image = UIImage(named: "lanternson")
            }
        } else {
            unlockNotice.setTitle("Unlocks at level \(LevelManager.lanternsUnlock)", for: .normal)
            unlockNotice.animateFadeInSlow()
        }
    }
    
    
    @IBAction func normalModeTapped(_ sender: UIButton) {
        switch outsideViewModel.prevMode() {
        case .watering, .removal:
            waterText.alpha = 0.0
            backgroundView.backgroundColor = Colors.pink

            removeText.alpha = 0.0
            normalText.alpha = 1.0
        case .planting:
            normalText.alpha = 0.0
        }

        outsideViewModel.setMode(button: .planting)
    }
    
    @IBAction func waterModeTapped(_ sender: UIButton) {
        switch outsideViewModel.prevMode() {
        case .planting, .removal:
            removeText.alpha = 0.0
            backgroundView.backgroundColor = Colors.blue

            waterText.alpha = 1.0
            normalText.alpha = 0.0
        case .watering:
            waterText.alpha = 0.0
        }

        outsideViewModel.setMode(button: .watering)
    }
    
    @IBAction func trowelModeTapped(_ sender: UIButton) {
        switch outsideViewModel.prevMode() {
        case .planting, .watering:
            waterText.alpha = 0.0
            backgroundView.backgroundColor = Colors.tan

            removeText.alpha = 1.0
            normalText.alpha = 0.0
        case .removal:
            removeText.alpha = 0.0
        }

        outsideViewModel.setMode(button: .removal)
    }
    
    @IBAction func catTouched(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if viewModel.getMovementType() == .staying {
                viewModel.stopTimer()
                cloudKitty.stopAnimating()
                cloudKitty.animationImages = AnimationManager.petAnimation
                cloudKitty.animationDuration = 1.0
                cloudKitty.startAnimating()
                viewModel.petted()
                // add EXP?
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            sleep()
        }
    }
    
    @IBAction func honorStandTapped(_ sender: UITapGestureRecognizer) {
        // add earnings to total
        if outsideViewModel.hasEarnings() {
            earningsView.isHidden = false
            earningsMessage.text = "You made \(outsideViewModel.earningsTotal()) coins in honor stand earnings!"
            earningsView.animateBounce()

            coinCount.text = viewModel.getCoins()
            coinImage.animateBounce()

            honorStandMoney.isHidden = true

            // update money inside
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.earningsView.isHidden = true
            }
        }
    }
    
    @IBAction func storeTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToStore", sender: Any?.self)
    }
    
    @IBAction func fencePlot1Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: fencePlot1)
    }
    
    @IBAction func fencePlot2Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: fencePlot2)
    }
    
    @IBAction func fencePlot3Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: fencePlot3)
    }
    
    @IBAction func fencePlot4Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: fencePlot4)
    }
    
    @IBAction func fencePlot5Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: fencePlot5)
    }
    
    @IBAction func fencePlot6Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: fencePlot6)
    }
    
    @IBAction func frontPlot1Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot1)
    }
    
    @IBAction func frontPlot2Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot2)
    }
    
    @IBAction func frontPlot3Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot3)
    }
    
    @IBAction func frontPlot4Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot4)
    }
    
    @IBAction func frontPlot5Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot5)
    }
    
    @IBAction func frontPlot6Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot6)
    }
    
    @IBAction func frontPlot7Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot7)
    }
    
    @IBAction func frontPlot8Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: frontPlot8)
    }
    
    @IBAction func succulentPot1Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: succulentPot1)
    }
    
    @IBAction func succulentPot2Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: succulentPot2)
    }
    
    @IBAction func succulentPot3Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: succulentPot3)
    }
    
    @IBAction func planterPlot1Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: planterPlot1)
    }
    
    @IBAction func planterPlot2Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: planterPlot2)
    }
    
    @IBAction func planterPlot3Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: planterPlot3)
    }
    
    @IBAction func tallPotPlotTapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: tallPotPlot)
    }
    
    @IBAction func vegetablePlot1Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: vegetablePlot1)
    }
    
    @IBAction func vegetablePlot2Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: vegetablePlot2)
    }
    
    @IBAction func vegetablePlot3Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: vegetablePlot3)
    }
    
    @IBAction func vegetablePlot4Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: vegetablePlot4)
    }
    
    @IBAction func vegetablePlot5Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: vegetablePlot5)
    }
    
    @IBAction func vegetablePlot6Tapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: vegetablePlot6)
    }
    
    @IBAction func smallPotPlotTapped(_ sender: UITapGestureRecognizer) {
        tappedPlant(image: smallPotPlot)
    }
    
    @IBAction func basketPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "viewBasket", sender: Any?.self)
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        stop()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
