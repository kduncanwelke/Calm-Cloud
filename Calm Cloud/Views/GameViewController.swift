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
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var beginGameButton: UIButton!
    @IBOutlet weak var gameOver: UIView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var areYouSure: UIView!
    @IBOutlet weak var plays: UILabel!
    @IBOutlet weak var playTimer: UILabel!
    @IBOutlet weak var gameView: SKView!

    // MARK: Variables

    var scene: GameScene!
    var level: GameLevel!
    private let gameViewModel = GameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let spriteKitView = gameView as SKView
        spriteKitView.isMultipleTouchEnabled = false

        scene = GameScene(size: spriteKitView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = Colors.pink

        scene.swipeHandler = handleSwipe(_:)
        
        spriteKitView.presentScene(scene)

        level = gameViewModel.getGameLevel()
        scene.level = level

        scene.addTiles()
        scene.isUserInteractionEnabled = false
    }

    func updateLabels() {
        currentScore.text = gameViewModel.getCurrentScore()
        currentMoves.text = gameViewModel.getCurrentMoves()
        plays.text = gameViewModel.getCurrentPlays()
    }

    func shuffle() {
        scene.removeSprites()
        let newToys = level.shuffle()
        scene.addSprites(for: newToys)
    }

    func beginGame() {
        level = gameViewModel.getGameLevel()
        level = gameViewModel.getGameLevel()
        scene.level = level

        gameInfoStackView.isHidden = false
        selectLabel.isHidden = true
        modeDescription.isHidden = true
        modeSegmentedControl.isHidden = true

        switch gameViewModel.getMode() {
        case .normal:
            clouds.isHidden = false
            plays.isHidden = false
            playTimer.isHidden = false
        case .zen:
            clouds.isHidden = true
            plays.isHidden = true
            playTimer.isHidden = true
        }

        gameViewModel.startGame()
        updateLabels()
        level.resetCombo()
        shuffle()
        scene.isUserInteractionEnabled = true
    }

    func beginNextTurn() {
        level.resetCombo()
        level.detectPossibleSwaps()
        decrementMoves()
        view.isUserInteractionEnabled = true
    }

    func quitThisGame() {
        gameViewModel.terminateGame()
        clouds.isHidden = true
        plays.isHidden = true
        playTimer.isHidden = true
        beginGameButton.isHidden = false
        gameInfoStackView.isHidden = true
        selectLabel.isHidden = false
        modeDescription.isHidden = false
        modeSegmentedControl.isHidden = false
        scene.isUserInteractionEnabled = false
    }

    func showGameOver() {
        gameViewModel.gameOver()
        gameOver.isHidden = false

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
            if let text = gameViewModel.decreaseMoves() {
                result.text = text
                showGameOver()
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

        scene.animateMatchedCookies(for: chains) {
            for chain in chains {
                self.gameViewModel.addToScore(value: chain.score)
            }

            self.updateLabels()

            let columns = self.level.fillHoles()

            self.scene.animateFallingCookies(in: columns) {
                let columns = self.level.topUp()

                self.scene.animateNewCookies(in: columns) {
                    self.handleMatches()
                }
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
        beginGameButton.isHidden = true
        beginGame()
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

    @IBAction func backPressed(_ sender: UIButton) {
        if gameViewModel.isGameInProgress {
            areYouSure.isHidden = false
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
