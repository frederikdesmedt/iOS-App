//
//  GameScene.swift
//  Projecten FDS
//
//  Created by Frederik De Smedt on 5/11/15.
//  Copyright (c) 2015 Frederik De Smedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let game = Game()
    
    var cardBackgrounds: [Game.Location: SKNode] = [:]
    var gameCards: [Game.Location: SKNode] = [:]
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    
    var cardSize: CGFloat!
    let margin: CGFloat = 5
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        
        initGestureRecognizerForDirection(.Left, action: "swipedLeft:")
        initGestureRecognizerForDirection(.Right, action: "swipedRight:")
        initGestureRecognizerForDirection(.Up, action: "swipedUp:")
        initGestureRecognizerForDirection(.Down, action: "swipedDown:")
        
        // Fill fixed-size cards with nil
        backgroundColor = UIColor(red: 187 / 255, green: 173 / 255, blue: 160 / 255, alpha: 1)
        game.delegate = self
        game.addRandomValue(game.randomLocation!)
        createBoard()
    }
    
    func createBoard() {
        // Skip board generation if there is no SKView
        guard let _ = view else {
            return
        }
        
        size = view!.bounds.size
        viewWidth = min(size.width, size.height)
        viewHeight = viewWidth
        cardSize = min(self.viewWidth / CGFloat(Game.widthInCards) - margin * 2, self.viewHeight / CGFloat(Game.heightInCards) - margin * 2)
        
        // Padding to center board in screen
        let paddingX = min((size.height - size.width) / 2, 0)
        let paddingY = min((size.width - size.height) / 2, 0)
        
        // Reduce multi-dimensional array to one dimensional, filter out all nil values, "unwrap" the optional values
        removeChildrenInArray(Array(cardBackgrounds.values))
        
        // Display background card layout on the screen
        Game.forEachLocation {
            let card = self.createCard()
            self.cardBackgrounds[Game.Location(x: $0.x, y: $0.y)] = card
            let x = self.viewWidth * CGFloat($0.x) / CGFloat(Game.widthInCards) + self.cardSize / 2 + self.margin - paddingX
            let y = self.viewHeight * CGFloat($0.y) / CGFloat(Game.heightInCards) + self.cardSize / 2 + self.margin - paddingY
            card.position = CGPoint(x: x, y: y)
            self.addChild(card)
        }
    }
    
    func createCard() -> SKSpriteNode {
        return SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2), size: CGSize(width: cardSize, height: cardSize))
    }
    
    var cards: [Game.Location: SKSpriteNode] = [:]
    
    func addCard(position: Game.Location, card: SKSpriteNode) {
        addChild(card)
        cards[position] = card
    }
    
    func removeCard(position: Game.Location) {
        if let card = cards[position] {
            removeChildrenInArray([card])
            cards.removeValueForKey(position)
        }
    }
    
    func initGestureRecognizerForDirection(direction: UISwipeGestureRecognizerDirection, action: String) {
        let recognizer = UISwipeGestureRecognizer(target: self, action: Selector(action))
        recognizer.direction = direction
        view!.addGestureRecognizer(recognizer)
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}

extension GameScene {
    
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        game.swipeLeft()
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        game.swipeRight()
    }
    
    func swipedUp(sender: UISwipeGestureRecognizer) {
        game.swipeUp()
    }
    
    func swipedDown(sender: UISwipeGestureRecognizer) {
        game.swipeDown()
    }
    
    func createLabel(value: String) -> SKLabelNode {
        let label = SKLabelNode(text: String(value))
        label.fontName = "AvenirNext"
        label.fontSize = 24
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return label
    }
}

extension GameScene: GameDelegate {
    
    func newCardWasAdded(location: Game.Location, value: Int) {
        guard let backgroundCard = cardBackgrounds[location] else {
            createBoard()
            return newCardWasAdded(location, value: value)
        }
        
        let card = createCard()
        card.position = backgroundCard.position
        let label = createLabel(String(value))
        card.addChild(label)
        addCard(location, card: card)
    }
    
    func cardsDidMerge(from: Game.Location, to: Game.Location, oldValue: Int, newValue: Int) {
        guard let backgroundCard = cardBackgrounds[to] else {
            return debugPrint("Background card unavailable")
        }
        
        let card = createCard()
        removeCard(to)
        card.position = backgroundCard.position
        let label = createLabel(String(newValue))
        card.addChild(label)
        addCard(to, card: card)
        removeCard(from)
    }
    
    func game(game: Game, score: Int) {
        // TODO: Implement game over screen and log high score
    }
}
