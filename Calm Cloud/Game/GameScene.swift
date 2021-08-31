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

    var swipeHandler: ((Swap) -> Void)?

    var level: GameLevel!

    let tileWidth: CGFloat = 40.0
    let tileHeight: CGFloat = 40.0

    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?

    let gameLayer = SKNode()
    let toyLayer = SKNode()
    let tileLayer = SKNode()

    override init(size: CGSize) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(gameLayer)
        let layerPosition = CGPoint(x: -tileWidth * CGFloat(totalColumns)/2, y: -tileHeight * CGFloat(totalRows)/2)
        tileLayer.position = layerPosition
        gameLayer.addChild(tileLayer)
        toyLayer.position = layerPosition
        gameLayer.addChild(toyLayer)

        let _ = SKLabelNode(fontNamed: "GillSans-BoldItalic")
    }

    // MARK: Logic

    func addSprites(for toys: Set<Toy>) {
        for toy in toys {
            let sprite = SKSpriteNode(imageNamed: toy.toyType.spriteName)
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: toy.column, row: toy.row)
            toyLayer.addChild(sprite)
            toy.sprite = sprite

            sprite.alpha = 0
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.25, withRange: 0.5), SKAction.group([SKAction.fadeIn(withDuration: 0.25), SKAction.scale(to: 1.0, duration: 0.25)])]))
        }
    }

    func removeSprites() {
        toyLayer.removeAllChildren()
    }

    func addTiles() {
        for row in 0..<totalRows {
            for column in 0..<totalColumns {
                if level.tileAt(column: column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "bluetile")
                    tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    tileLayer.addChild(tileNode)
                }
            }
        }
    }

    // MARK: Animations

    func animateScore(for chain: Chain) {
        guard let firstSprite = chain.firstToy().sprite, let lastSprite = chain.lastToy().sprite else { return }

        let centerpoint = CGPoint(x: (firstSprite.position.x + lastSprite.position.x)/2, y: (firstSprite.position.y + lastSprite.position.y)/2 - 8)

        let scoreLabel = SKLabelNode(fontNamed: "GillSans-BoldItalic")
        scoreLabel.fontSize = 16
        scoreLabel.text = "\(chain.score)"
        scoreLabel.position = centerpoint
        scoreLabel.zPosition = 300
        toyLayer.addChild(scoreLabel)

        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 3), duration: 0.7)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }

    func animate(_ swap: Swap, completion: @escaping () -> Void) {
        guard let spriteA = swap.toyA.sprite, let spriteB = swap.toyB.sprite else { return }

        // put one sprite above the other
        spriteA.zPosition = 100
        spriteB.zPosition = 90

        let duration: TimeInterval = 0.3

        // create movements
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)

        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
    }

    func animateInvalidSwap(_ swap: Swap, completion: @escaping () -> Void) {
        guard let spriteA = swap.toyA.sprite, let spriteB = swap.toyB.sprite else { return }

        spriteA.zPosition = 100
        spriteB.zPosition = 90

        let duration: TimeInterval = 0.2

        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut

        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut

        spriteA.run(SKAction.sequence([moveA, moveB]), completion: completion)
        spriteB.run(SKAction.sequence([moveB, moveA]))
    }

    func animateMatchedCookies(for chains: Set<Chain>, completion: @escaping () -> Void) {
        for chain in chains {
            animateScore(for: chain)

            for toy in chain.toys {
                if let sprite = toy.sprite {
                    if sprite.action(forKey: "removing") == nil {
                        let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
                        scaleAction.timingMode = .easeOut

                        sprite.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]), withKey: "removing")
                    }
                }
            }
        }

        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }

    func animateFallingCookies(in columns: [[Toy]], completion: @escaping () -> Void) {
        var longestDuration: TimeInterval = 0

        for array in columns {
            for (index, toy) in array.enumerated() {
                let newPosition = pointFor(column: toy.column, row: toy.row)
                let delay = 0.05 + 0.15 * TimeInterval(index)

                let sprite = toy.sprite! // we know it exists

                let duration = TimeInterval(((sprite.position.y - newPosition.y) / tileHeight) * 0.1)
                longestDuration = max(longestDuration, duration + delay)

                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut

                sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.group([moveAction])]))
            }
        }

        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }

    func animateNewCookies(in columns: [[Toy]], completion: @escaping () -> Void) {
        var longestDuration: TimeInterval = 0

        for array in columns {
            let startRow = array[0].row + 1

            for (index, toy) in array.enumerated() {
                let sprite = SKSpriteNode(imageNamed: toy.toyType.spriteName)
                sprite.size = CGSize(width: tileWidth, height: tileHeight)
                sprite.position = pointFor(column: toy.column, row: startRow)

                toyLayer.addChild(sprite)
                toy.sprite = sprite

                let delay = 0.1 + 0.2 * TimeInterval(array.count - index - 1)
                let duration = TimeInterval(startRow - toy.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)

                let newPosition = pointFor(column: toy.column, row: toy.row)
                let moveAction = SKAction.move(to: newPosition, duration: longestDuration)
                moveAction.timingMode = .easeOut

                sprite.alpha = 0
                sprite.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.group([SKAction.fadeIn(withDuration: 0.05), moveAction])]))
            }
        }

        run(SKAction.wait(forDuration: longestDuration), completion: completion)
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

            // use closure to communicate successful swap
            if let handler = swipeHandler {
                let swap = Swap(toyA: fromToy, toyB: toToy)
                handler(swap)
            }
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


