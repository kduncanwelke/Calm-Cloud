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

    // MARK: Variables

    var scene: GameScene!
    var level: GameLevel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let spriteKitView = view as! SKView
        spriteKitView.isMultipleTouchEnabled = false

        scene = GameScene(size: spriteKitView.bounds.size)
        scene.scaleMode = .aspectFill

        spriteKitView.presentScene(scene)

        level = GameLevel()
        scene.level = level

        beginGame()
    }

    func shuffle() {
        let newToys = level.shuffle()
        scene.addSprites(for: newToys)
    }

    func beginGame() {
        shuffle()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
