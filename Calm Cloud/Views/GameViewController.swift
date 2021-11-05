//
//  GameViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/13/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var gameInfoStackView: UIStackView!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var currentMoves: UILabel!
    @IBOutlet weak var modeSelection: UIStackView!
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var modeDescription: UILabel!

    @IBOutlet weak var areYouSureDescription: UILabel!
    @IBOutlet weak var confirmQuit: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var beginGameButton: UIButton!
    @IBOutlet weak var gameOver: UIView!
    @IBOutlet weak var winnings: UILabel!
    @IBOutlet weak var noClouds: UIView!
    @IBOutlet weak var result: UIImageView!
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var areYouSure: UIView!
    @IBOutlet weak var plays: UILabel!
    @IBOutlet weak var playTimer: UILabel!
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var backButton: UIButton!

    
    // MARK: Variables

    var scene: GameScene!
    var level: GameLevel!
    private let gameViewModel = GameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(addCloud), name: NSNotification.Name(rawValue: "addCloud"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshClouds), name: NSNotification.Name(rawValue: "refreshClouds"), object: nil)

        gameViewModel.loadPlays()
        level = gameViewModel.getGameLevel()
        
        let spriteKitView = gameView as SKView
        spriteKitView.isMultipleTouchEnabled = false

        scene = GameScene(size: spriteKitView.bounds.size)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = Colors.pink

        scene.swipeHandler = handleSwipe(_:)
        
        spriteKitView.presentScene(scene)

        scene.level = level

        scene.addTiles()
        scene.isUserInteractionEnabled = false

        updateLabels()
        checkTimer()
    }

    func outOfSwaps() {
        showGameOver(noMoves: true)
    }

    @objc func refreshClouds() {
        gameViewModel.stopTimer()
        playTimer.text = "Full"
    }

    @objc func addCloud() {
        gameViewModel.savePlays(fromTimer: true)
        checkTimer()
    }

    func checkTimer() {
        if gameViewModel.startCloudTimer() && !gameViewModel.isTimerRunning() {
            CloudsTimer.beginTimer(label: playTimer)
            updateLabels()
        } else {
            plays.text = "\(gameViewModel.getCurrentClouds())"

            if gameViewModel.areCloudsFull() {
                playTimer.text = "Full"
            } else {
                playTimer.text = "-:--"
            }
        }
    }

    func updateLabels() {
        currentScore.text = gameViewModel.getCurrentScore()
        currentMoves.text = gameViewModel.getCurrentMoves()
        plays.text = "\(gameViewModel.getCurrentClouds())"
    }

    func shuffle() {
        scene.removeSprites()
        let newToys = level.shuffle()
        scene.addSprites(for: newToys)
    }

    func beginGame() {
        scene.removeTiles()

        level = gameViewModel.getGameLevel()

        gameInfoStackView.isHidden = false
        selectLabel.isHidden = true
        modeDescription.isHidden = true
        modeSegmentedControl.isHidden = true

        scene.level = level
        scene.addTiles()

        gameViewModel.startGame()
        updateLabels()
        level.resetCombo()
        shuffle()
        scene.isUserInteractionEnabled = true
        backButton.setTitle("Quit", for: .normal)
        checkTimer()
    }

    func beginNextTurn() {
        level.resetCombo()
        decrementMoves()

        // if no swaps, shuffle on zen mode, end on normal
        if level.detectPossibleSwaps() {
            print("no swaps")
            switch gameViewModel.getMode() {
            case .normal:
                outOfSwaps()
            case .zen:
                shuffle()
            }
        }

        view.isUserInteractionEnabled = true
    }

    func quitThisGame() {
        gameViewModel.terminateGame()
        backButton.setTitle("Back", for: .normal)
        beginGameButton.isHidden = false
        gameInfoStackView.isHidden = true
        selectLabel.isHidden = false
        modeDescription.isHidden = false
        modeSegmentedControl.isHidden = false
        scene.isUserInteractionEnabled = false
    }

    func showGameOver(noMoves: Bool) {
        gameViewModel.gameOver()
        gameOver.isHidden = false

        if noMoves {
            result.image = UIImage(named: "nomoves")
        }

        if gameViewModel.canPlayAgain() {
            playAgain.isEnabled = true
            playAgain.alpha = 1.0
        } else {
            playAgain.isEnabled = false
            playAgain.alpha = 0.5
        }

        scene.isUserInteractionEnabled = false
    }

    func decrementMoves() {
        switch gameViewModel.getMode() {
        case .normal:
            if let image = gameViewModel.decreaseMoves().image, let won = gameViewModel.decreaseMoves().won {
                result.image = image

                if won {
                    print("won")
                    winnings.text = "\(gameViewModel.giveCoins()) coins and \(gameViewModel.giveEXP())EXP won!"
                }

                gameOver.isHidden = false
                showGameOver(noMoves: false)
                return
            }

            updateLabels()
        case .zen:
            updateLabels()
        }
    }

    func handleSwipe(_ swap: Swap) {
        // perform swap in model
        view.isUserInteractionEnabled = false

        if level.isPossibleSwap(swap) {
            level.performSwap(swap)

            // animate swap
            scene.animate(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.isUserInteractionEnabled = true
            }
        }
    }

    func handleMatches() {
        let chains = level.removeMatches()

        if chains.count == 0 {
            beginNextTurn()
            return
        }

        scene.animateMatchedToys(for: chains) {
            for chain in chains {
                self.gameViewModel.addToScore(value: chain.score)
            }

            self.updateLabels()

            let columns = self.level.fillHoles()

            self.scene.animateFallingToys(in: columns) {
                let columns = self.level.topUp()

                self.scene.animateNewToys(in: columns) {
                    self.handleMatches()
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "visitStore" {
            if let destination = segue.destination as? StoreViewController {
                destination.selectedIndex = 2
            }
        }
    }


    // MARK: IBOutlets

    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        gameViewModel.changeMode(segment: modeSegmentedControl.selectedSegmentIndex)

        switch gameViewModel.getMode() {
        case .normal:
            modeDescription.text = "Use Clouds to play levels and win rewards!"
        case .zen:
            modeDescription.text = "Play endlessly without rewards for relaxation"
        }
    }

    @IBAction func beginGamePressed(_ sender: UIButton) {
        if gameViewModel.canPlayAgain() {
            beginGameButton.isHidden = true
            beginGame()
        } else {
            // TO DO: show message
            noClouds.isHidden = false
        }
    }

    @IBAction func playAgainPressed(_ sender: UIButton) {
        gameOver.isHidden = true
        scene.isUserInteractionEnabled = true
        beginGame()
    }

    @IBAction func quitPressed(_ sender: UIButton) {
        gameOver.isHidden = true
        quitThisGame()
    }

    @IBAction func resumeGame(_ sender: UIButton) {
        areYouSure.isHidden = true
    }

    @IBAction func quitGame(_ sender: UIButton) {
        areYouSure.isHidden = true
        quitThisGame()
    }

    @IBAction func visitStore(_ sender: UIButton) {
        noClouds.isHidden = true
        performSegue(withIdentifier: "visitStore", sender: Any?.self)
    }

    @IBAction func closeNoClouds(_ sender: UIButton) {
        noClouds.isHidden = true
    }

    @IBAction func backPressed(_ sender: UIButton) {
        if gameViewModel.isGameInProgress {
            areYouSure.isHidden = false
        } else {
            gameViewModel.stopTimer()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
