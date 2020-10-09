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
    
    var selectedPlot = 0
    var wateringModeOn = false
    var trowelModeOn = false
    var tappedImage: UIImageView?
    var stopped = false
    var mode: Mode = .planting
    var lightsOn = false
    var rotated = false
    var name = ""
    
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
        
        
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
        
        plusEXPLabel.alpha = 0.0
        plusEXPLabelAlt.alpha = 0.0
        honorStandMoney.isHidden = true
        coinCount.text = "\(MoneyManager.total)"
        earningsView.isHidden = true
        
        normalText.alpha = 1.0
        waterText.alpha = 0.0
        removeText.alpha = 0.0
        
        AnimationManager.outsideLocation = .back
        AnimationManager.movement = .staying
        sleep()
        
        loadUI()
        loadInventory()
        loadPlots()
        DataFunctions.loadHarvest()
        DataFunctions.loadHonorStand()
        DataFunctions.saveInventory()
        checkForPurchases()
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
        if AnimationManager.movement == .staying {
            cloudKitty.stopAnimating()
            AnimationTimer.stop()
        }
        stopMovingOutside()
    }
    
    // MARK: Custom functions
    
    func loadUI() {
        setTimeAndWeather()
        
        // update level
        levelLabel.text = "\(LevelManager.currentLevel)"
        expLabel.text = "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
        var prog: Float = Float(LevelManager.currentEXP) / Float(LevelManager.maxEXP)
        levelProgress.setProgress(prog, animated: true)
    }
    
    func setTimeAndWeather() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        print(WeatherManager.currentWeather)
        switch WeatherManager.currentWeather {
        case .clearWarm:
            weather.isHidden = true
             
            if hour > 6 && hour < 20 {
                outsideImage.image = UIImage(named: "outside")
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.outside.resourceName, type: Sounds.outside.type)
                Sound.startPlaying()
            } else {
                 outsideImage.image = UIImage(named: "backgroundnight")
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.night.resourceName, type: Sounds.night.type)
                Sound.startPlaying()
            }
        case .clearCool:
            weather.isHidden = true
             
            if hour > 6 && hour < 20 {
                 outsideImage.image = UIImage(named: "outsidefall")
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.outsideFallWinter.resourceName, type: Sounds.outsideFallWinter.type)
                Sound.startPlaying()
            } else {
                outsideImage.image = UIImage(named: "outsidefallnight")
                Sound.stopPlaying()
                Sound.loadSound(resourceName: Sounds.outsideFallWinterNight.resourceName, type: Sounds.outsideFallWinterNight.type)
                Sound.startPlaying()
            }
        case .rainingWarm:
            weather.isHidden = false
            
            if hour > 6 && hour < 20 {
                outsideImage.image = UIImage(named: "outside")
            } else {
                outsideImage.image = UIImage(named: "backgroundnight")
            }
            
            // raining animation
            weather.animationImages = WeatherManager.rainImages
            weather.animationDuration = 0.3
            weather.startAnimating()
            
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.rainOutdoors.resourceName, type: Sounds.rainOutdoors.type)
            Sound.startPlaying()
        case .rainingCool:
            weather.isHidden = false
            
            if hour > 6 && hour < 20 {
                outsideImage.image = UIImage(named: "outsidefall")
            } else {
                outsideImage.image = UIImage(named: "outsidefallnight")
            }
            
            // add raining animation
            weather.animationImages = WeatherManager.rainImages
            weather.animationDuration = 0.3
            weather.startAnimating()
            
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.rainOutdoors.resourceName, type: Sounds.rainOutdoors.type)
            Sound.startPlaying()
        case .snowing:
            weather.isHidden = false
            
            if hour > 6 && hour < 20 {
                outsideImage.image = UIImage(named: "outsidesnow")
            } else {
                outsideImage.image = UIImage(named: "outsidesnownight")
            }
            
            // add snowing animation
            weather.animationImages = WeatherManager.snowImages
            weather.animationDuration = 2.8
            weather.startAnimating()
            
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.snow.resourceName, type: Sounds.snow.type)
            Sound.startPlaying()
        case .snowOnGround:
            weather.isHidden = true
            
            if hour > 6 && hour < 20 {
                outsideImage.image = UIImage(named: "outsidesnow")
            } else {
                outsideImage.image = UIImage(named: "outsidesnownight")
            }
            
            Sound.stopPlaying()
            Sound.loadSound(resourceName: Sounds.snow.resourceName, type: Sounds.snow.type)
            Sound.startPlaying()
        }
    }
    
    func getName() {
        let planting = Plantings.plantings.filter { $0.id == PlantManager.chosen }.first
        
        guard let plant = planting else { return }
        
        for seedling in Plantings.seedlings {
            if seedling.plant == Plant(rawValue: Int(plant.plant))! {
                name = seedling.name
            }
        }
    }
    
    func checkForPurchases() {
        if let income = Harvested.randomPurchases() {
            // show collectable money
            MoneyManager.earnings += income
            if income != 0 {
                honorStandMoney.isHidden = false
                DataFunctions.saveMoney()
                DataFunctions.saveHonorStandItems()
            }
        }
        
        loadHonorStand()
    }
    
    @objc func loadHonorStand() {
        var index = 0
        
        if MoneyManager.earnings != 0 {
            honorStandMoney.isHidden = false
        }
        
        // show more crowded image if more quantity
        for (type, quantity) in Harvested.inStand {
            if honorStandImages[index].image == nil {
                if quantity > 0 {
                    honorStandImages[index].image = Harvested.getStandImage(plant: type)
                    index += 1
                }
            }
        }
    }
    
    @objc func updateLevelFromBasket() {
        // refresh these level labels when exp is gained outside
        levelLabel.text = "\(LevelManager.currentLevel)"
        expLabel.text = "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
    }
    
    @objc func updateCoins() {
        coinCount.text = "\(MoneyManager.total)"
        coinImage.animateBounce()
        
        // resave money
        DataFunctions.saveMoney()
    }
    
    func showEXP(near: UIImageView, exp: Int) {
        // show exp
        // choose whichever label is currently not visible
        if plusEXPLabel.alpha == 0.0 {
            print("label one")
            print(plusEXPLabel.alpha)
            plusEXPLabel.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabel.text = "+\(exp) EXP"
            plusEXPLabel.alpha = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                self.plusEXPLabel.fadeOut()
            }
        } else if plusEXPLabelAlt.alpha == 0.0 {
            print("label two")
            plusEXPLabelAlt.center = CGPoint(x: near.frame.midX, y: near.frame.midY-30)
            plusEXPLabelAlt.text = "+\(exp) EXP"
            plusEXPLabelAlt.alpha = 1.0
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                self.plusEXPLabelAlt.fadeOut()
            }
        }
    }
    
    func updateEXP(with amount: Int) {
        // update exp and save
        LevelManager.currentEXP += amount
        
        if LevelManager.currentEXP >= LevelManager.maxEXP {
            LevelManager.currentLevel += 1
            levelLabel.text = "\(LevelManager.currentLevel)"
            LevelManager.calculateLevel()
            levelLabel.animateBounce()
            showLevelUp()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "levelUp"), object: nil)
        }
        
        expLabel.text = "\(LevelManager.currentEXP)/\(LevelManager.maxEXP)"
        print(LevelManager.currentEXP)
        print(LevelManager.maxEXP)
        var prog: Float = Float(LevelManager.currentEXP) / Float(LevelManager.maxEXP)
        levelProgress.setProgress(prog, animated: true)
        DataFunctions.saveLevel()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLevelFromOutside"), object: nil)
    }
    
    func showLevelUp() {
        // show level up image
        view.bringSubviewToFront(levelUpImage)
        levelUpImage.animateBounce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.view.sendSubviewToBack(self.levelUpImage)
        }
    }
    
    @objc func closePopUp() {
        // close message popup
        view.sendSubviewToBack(messageContainer)
    }
    
    @objc func hideMiniGame() {
        view.sendSubviewToBack(cupsMiniGameContainer)
        stopped = false
        stopMovingOutside()
    }
    
    @objc func harvestPlant() {
        // close message popup
        view.sendSubviewToBack(harvestContainer)
        
        // remove plant image and delete save
        
        deletePlanting(id: selectedPlot)
        
        // show exp gain
        if let image = tappedImage {
            showEXP(near: image, exp: 15)
            updateEXP(with: 15)
            
            // update image
            image.image = PlantManager.getStage(halfDaysOfCare: nil, plant: .none, lastWatered: nil, mature: nil)
        }
        
        // update count and save
        print(PlantManager.selected)
        Harvested.basketCounts[PlantManager.selected]! += 1
        DataFunctions.saveHarvest()
    }
    
    @objc func removePlant() {
        // close message popup
        view.sendSubviewToBack(removeContainer)
        
        // remove plant image and delete save
        deletePlanting(id: selectedPlot)
        if let image = tappedImage {
            image.image = PlantManager.getStage(halfDaysOfCare: nil, plant: .none, lastWatered: nil, mature: nil)
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
        DataFunctions.saveInventory()
        savePlanting(id: selectedPlot, plant: PlantManager.selected.rawValue)
        
        var imageToUpdate: UIImageView
        updateEXP(with: 10)
        
        if selectedPlot == 1 {
            imageToUpdate = fencePlot1
        } else if selectedPlot == 2 {
            imageToUpdate = fencePlot2
        } else if selectedPlot == 3 {
            imageToUpdate = fencePlot3
        } else if selectedPlot == 4 {
            imageToUpdate = fencePlot4
        } else if selectedPlot == 5 {
           imageToUpdate = fencePlot5
        } else if selectedPlot == 6 {
            imageToUpdate = fencePlot6
        } else if selectedPlot == 7 {
            imageToUpdate = frontPlot1
        } else if selectedPlot == 8 {
            imageToUpdate = frontPlot2
        } else if selectedPlot == 9 {
            imageToUpdate = frontPlot3
        } else if selectedPlot == 10 {
            imageToUpdate = frontPlot4
        } else if selectedPlot == 11 {
            imageToUpdate = frontPlot5
        } else if selectedPlot == 12 {
            imageToUpdate = frontPlot6
        } else if selectedPlot == 13 {
            imageToUpdate = frontPlot7
        } else if selectedPlot == 14 {
            imageToUpdate = frontPlot8
        } else if selectedPlot == 15 {
            imageToUpdate = succulentPot1
        } else if selectedPlot == 16 {
            imageToUpdate = succulentPot2
        } else if selectedPlot == 17 {
            imageToUpdate = succulentPot3
        } else if selectedPlot == 18 {
            imageToUpdate = planterPlot1
        } else if selectedPlot == 19 {
            imageToUpdate = planterPlot2
        } else if selectedPlot == 20 {
            imageToUpdate = planterPlot3
        } else if selectedPlot == 21 {
            imageToUpdate = tallPotPlot
        } else if selectedPlot == 22 {
            imageToUpdate = vegetablePlot1
        } else if selectedPlot == 23 {
            imageToUpdate = vegetablePlot2
        } else if selectedPlot == 24 {
            imageToUpdate = vegetablePlot3
        } else if selectedPlot == 25 {
            imageToUpdate = vegetablePlot4
        } else if selectedPlot == 26 {
            imageToUpdate = vegetablePlot5
        } else if selectedPlot == 27 {
            imageToUpdate = vegetablePlot6
        } else {
            imageToUpdate = smallPotPlot
        }
                
        // show exp feedback
        showEXP(near: imageToUpdate, exp: 10)
        // update image
        imageToUpdate.image = PlantManager.getStage(halfDaysOfCare: 0, plant: PlantManager.selected, lastWatered: nil, mature: nil)
    }
    
    func setPlotArea() {
        if selectedPlot < 15 {
            PlantManager.area = .rows
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
    }
    
    func tappedPlant(image: UIImageView) {
        setPlotArea()
        
        switch mode {
        case .planting:
            // determine if plot is empty
            if image.isMatch(with: PlantManager.emptyPlots) {
                view.bringSubviewToFront(messageContainer)
            } else if image.isMatch(with: PlantManager.maturePlants) {
                // harvest prompt for mature plants
                print("mature plant")
                tappedImage = image
                PlantManager.chosen = selectedPlot
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                view.bringSubviewToFront(harvestContainer)
            } else {
                // otherwise simply show identification
                PlantManager.chosen = selectedPlot
                getName()
                plantName.setTitle("\(name)", for: .normal)
                plantName.animateFadeInSlow()
            }
        case .watering:
            if image.isMatch(with: PlantManager.wiltedPlants) {
                // cannot water wilted plant
                return
            }
            
            saveWatering(id: selectedPlot)
        case .removal:
            tappedImage = image
            PlantManager.chosen = selectedPlot
            
            // determine if plot has wilted plant
            if image.isMatch(with: PlantManager.wiltedPlants) {
                print("wilted plant")
                view.bringSubviewToFront(removeContainer)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadWilted"), object: nil)
            } else if !image.isMatch(with: PlantManager.emptyPlots) {
                // make sure plot is not empty
                view.bringSubviewToFront(removeContainer)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadRemove"), object: nil)
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
    
    @IBAction func miniGameTapped(_ sender: UIButton) {
        // show mini game
        stopped = true
        if AnimationManager.movement == .staying {
            cloudKitty.stopAnimating()
            AnimationTimer.stop()
        }
        
        view.bringSubviewToFront(cupsMiniGameContainer)
        cupsMiniGameContainer.animateBounce()
    }
    
    @IBAction func inventoryTapped(_ sender: UIButton) {
        PlantManager.area = .none
        view.bringSubviewToFront(inventoryContainer)
        inventoryContainer.animateBounce()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @IBAction func onOffPressed(_ sender: UIButton) {
        if LevelManager.currentLevel >= LevelManager.lanternsUnlock {
            if lightsOn {
                lightsOn = false
                lanterns.image = UIImage(named: "lanternsoff")
            } else {
                lightsOn = true
                lanterns.image = UIImage(named: "lanternson")
            }
        } else {
            unlockNotice.setTitle("Unlocks at level \(LevelManager.lanternsUnlock)", for: .normal)
            unlockNotice.animateFadeInSlow()
        }
    }
    
    
    @IBAction func normalModeTapped(_ sender: UIButton) {
        if mode != .planting {
            mode = .planting
            normalText.alpha = 1.0
            waterText.alpha = 0.0
            removeText.alpha = 0.0
            backgroundView.backgroundColor = Colors.pink
        } else {
            if normalText.alpha == 1.0 {
                normalText.alpha = 0.0
            } else {
                normalText.alpha = 1.0
            }
        }
    }
    
    @IBAction func waterModeTapped(_ sender: UIButton) {
        // toggle watering mode
        if mode != .watering {
            if mode == .removal {
                removeText.alpha = 0.0
            }
            
            mode = .watering
            backgroundView.backgroundColor = Colors.blue
           
            waterText.alpha = 1.0
            normalText.alpha = 0.0
        } else {
            mode = .planting
            backgroundView.backgroundColor = Colors.pink
            waterText.alpha = 0.0
        }
    }
    
    @IBAction func trowelModeTapped(_ sender: UIButton) {
        if mode != .removal {
            if mode == .watering {
                waterText.alpha = 0.0
            }
            
            mode = .removal
            backgroundView.backgroundColor = Colors.tan
            
            removeText.alpha = 1.0
            normalText.alpha = 0.0
        } else {
            mode = .planting
            backgroundView.backgroundColor = Colors.pink
            removeText.alpha = 0.0
        }
    }
    
    @IBAction func catTouched(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if AnimationManager.movement == .staying {
                AnimationTimer.stop()
                cloudKitty.stopAnimating()
                cloudKitty.animationImages = AnimationManager.petAnimation
                cloudKitty.animationDuration = 1.0
                cloudKitty.startAnimating()
                // hasBeenPet = true
                // add EXP?
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            stopMovingOutside()
        }
    }
    
    @IBAction func honorStandTapped(_ sender: UITapGestureRecognizer) {
        print("honor stand tapped")
        print("\(MoneyManager.earnings)")
        // add earnings to total
        if MoneyManager.earnings != 0 {
            earningsView.isHidden = false
            earningsMessage.text = "You made \(MoneyManager.earnings) coins in honor stand earnings!"
            earningsView.animateBounce()
            
            MoneyManager.total += MoneyManager.earnings
            coinCount.text = "\(MoneyManager.total)"
            coinImage.animateBounce()
            
            // clear out earnings
            MoneyManager.earnings = 0
            
            // resave money
            DataFunctions.saveMoney()
            honorStandMoney.isHidden = true
            
            // update money inside
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMoney"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
                self.earningsView.isHidden = true
            }
        }
    }
    
    @IBAction func storeTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToStore", sender: Any?.self)
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
        print("tapped")
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
    
    @IBAction func basketPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "viewBasket", sender: Any?.self)
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        cloudKitty.stopAnimating()
        AnimationTimer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
}
