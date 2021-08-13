//
//  GameScene.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/13/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {

    var level: GameLevel!

    let tileWidth: CGFloat = 35.0
    let tileHeight: CGFloat = 35.0

    let gameLayer = SKNode()
    let toyLayer = SKNode()

    override init(size: CGSize) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //let background = SKSpriteNode(imageNamed: "background")
        //background.size = size
        //addChild(background)

        addChild(gameLayer)
        let layerPosition = CGPoint(x: -tileWidth * CGFloat(totalColumns)/2, y: -tileHeight * CGFloat(totalRows)/2)
        toyLayer.position = layerPosition

        gameLayer.addChild(toyLayer)

    }

    func addSprites(for toys: Set<Toy>) {
        for toy in toys {
            let sprite = SKSpriteNode(imageNamed: toy.toyType.spriteName)
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: toy.column, row: toy.row)
            toyLayer.addChild(sprite)
            toy.sprite = sprite
        }
    }

    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column) * tileWidth + tileWidth/2, y: CGFloat(row) * tileHeight + tileHeight/2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


