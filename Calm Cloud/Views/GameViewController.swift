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

    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var currentMoves: UILabel!
    @IBOutlet weak var gameOver: UIView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var playAgain: UIButton!


    // MARK: Variables

    var scene: GameScene!
    var level: GameLevel!
    var movesLeft = 0
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let spriteKitView = view as! SKView
        spriteKitView.isMultipleTouchEnabled = false

        scene = GameScene(size: spriteKitView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = Colors.pink

        scene.swipeHandler = handleSwipe(_:)
        
        spriteKitView.presentScene(scene)

        level = GameLevel(filename: "level_5")
        scene.level = level

        beginGame()
    }

    func updateLabels() {
        currentScore.text = "\(score)/\(level.targetScore)"
        currentMoves.text = "\(movesLeft)"
    }

    func shuffle() {
        let newToys = level.shuffle()
        scene.addSprites(for: newToys)
    }

    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetCombo()
        shuffle()
    }

    func beginNextTurn() {
        level.resetCombo()
        level.detectPossibleSwaps()
        decrementMoves()
        view.isUserInteractionEnabled = true
    }

    func decrementMoves() {
        movesLeft -= 1
        updateLabels()
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
                self.score += chain.score
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

    @IBAction func playAgainPressed(_ sender: UIButton) {
    }

    @IBAction func quitPressed(_ sender: UIButton) {
    }

    @IBAction func backPressed(_ sender: UIButton) {
        // TO DO: confirm quit
        self.dismiss(animated: true, completion: nil)
    }
}
