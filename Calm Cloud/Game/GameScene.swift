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

    let tileWidth: CGFloat = 40.0
    let tileHeight: CGFloat = 40.0

    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?

    let gameLayer = SKNode()
    let toyLayer = SKNode()

    override init(size: CGSize) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // FIXME: proper background for game
        let background = SKSpriteNode(imageNamed: "idea")
        background.size = self.size
        addChild(background)

        addChild(gameLayer)
        let layerPosition = CGPoint(x: -tileWidth * CGFloat(totalColumns)/2, y: -tileHeight * CGFloat(totalRows)/2)
        toyLayer.position = layerPosition

        gameLayer.addChild(toyLayer)

    }

    // MARK: Logic

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
        // find point for a given location
        return CGPoint(x: CGFloat(column) * tileWidth + tileWidth/2, y: CGFloat(row) * tileHeight + tileHeight/2)
    }

    private func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        // find column and row based on tapped point
        if point.x >= 0 && point.x < CGFloat(totalColumns) * tileWidth && point.y >= 0 && point.y < CGFloat(totalRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0)
        }
    }

    private func trySwap(horizontal: Int, vertical: Int) {
        guard let columnSwipe = swipeFromColumn, let rowSwipe = swipeFromRow else { return }

        // get target location
        let toColumn = columnSwipe + horizontal
        let toRow = rowSwipe + vertical

        // check that swipe is within play area
        guard toColumn >= 0 && toColumn < totalColumns else { return }
        guard toRow >= 0 && toRow < totalRows else { return }

        // swap items
        if let toToy = level.toy(atColumn: toColumn, row: toRow), let fromToy = level.toy(atColumn: columnSwipe, row: rowSwipe) {
            print("swapping \(toToy) and \(fromToy)")
        }
    }

    // MARK: Interaction

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let event = touches.first else { return }

        // get location and turn into point
        let location = event.location(in: toyLayer)
        let (success, column, row) = convertPoint(point: location)

        // if point is within game get toy for location and its column and row
        if success {
            if let toy = level.toy(atColumn: column, row: row) {
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let columnSwipe = swipeFromColumn, let rowSwipe = swipeFromRow else { return }

        guard let event = touches.first else { return }

        // get location and turn into point
        let location = event.location(in: toyLayer)
        let (success, column, row) = convertPoint(point: location)

        if success {
            var horizontalMove = 0
            var verticalMove = 0

            // figure out swipe direction
            if column < columnSwipe {
                horizontalMove = -1
            } else if column > columnSwipe {
                horizontalMove = 1
            } else if row < rowSwipe {
                verticalMove = -1
            } else if row > rowSwipe {
                verticalMove = 1
            }

            // attempt swap, reset swipe
            if horizontalMove != 0 || verticalMove != 0 {
                trySwap(horizontal: horizontalMove, vertical: verticalMove)

                swipeFromColumn = nil
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromColumn = nil
        swipeFromRow = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


