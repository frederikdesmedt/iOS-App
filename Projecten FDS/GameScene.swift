//
//  GameScene.swift
//  Projecten FDS
//
//  Created by Frederik De Smedt on 5/11/15.
//  Copyright (c) 2015 Frederik De Smedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var game: Game! {
        didSet {
            game.shouldGenerateNegativeValues = userDefaults.boolForKey("negative")
        }
    }
    
    var cardBackgrounds: [Game.Location: SKNode] = [:]
    var gameCards: [Game.Location: SKNode] = [:]
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var viewController: GameViewController!
    var shouldAllowSwiping = true
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var cardSize: CGFloat!
    let margin: CGFloat = 5
    var gameUpdated = false
    
    var boardDimensions: CGSize?
    
    override func didChangeSize(oldSize: CGSize) {
        if size != oldSize {
            createBoard()
        }
    }
    
    override func didMoveToView(view: SKView) {
        scaleMode = .ResizeFill
        
        initGestureRecognizerForDirection(.Left, action: "swipedLeft:")
        initGestureRecognizerForDirection(.Right, action: "swipedRight:")
        initGestureRecognizerForDirection(.Up, action: "swipedUp:")
        initGestureRecognizerForDirection(.Down, action: "swipedDown:")
        
        // Fill fixed-size cards with nil
        backgroundColor = UIColor(red: 187 / 255, green: 173 / 255, blue: 160 / 255, alpha: 1)
        game.delegate = self
        
        if game.usedCardsCount == 0 {
            game.addRandomValue(game.randomLocation!)
        } else {
            Game.forEachLocation {
                let value = self.game.valueForLocation($0)
                if value != 0 {
                    self.newCardWasAdded(self.game, location: $0, value: value)
                }
            }
        }
    }
    
    func createBoard(explicit: Bool = false) {
        // Skip board generation if there is no SKView
        if game == nil {
            game = Game()
        }
        
        guard let _ = view else {
            return
        }
        
        size = view!.bounds.size
        
        if size == boardDimensions && !explicit {
            return
        }
        
        boardDimensions = size
        
        viewWidth = min(size.width, size.height)
        viewHeight = viewWidth
        cardSize = min(self.viewWidth / CGFloat(Game.widthInCards) - margin * 2, self.viewHeight / CGFloat(Game.heightInCards) - margin * 2)
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone where UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation):
            anchorPoint = CGPoint(x: 0.25, y: 0)
        case .Phone where UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation):
            anchorPoint = CGPoint(x: 0, y: 0.25)
        case .Pad where UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation):
            anchorPoint = CGPoint(x: 0.15, y: 0)
        case .Pad where UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation):
            anchorPoint = CGPoint(x: 0, y: 0.1)
        default:
            anchorPoint = CGPoint(x: 0, y: 0)
        }
        
        // Reduce multi-dimensional array to one dimensional, filter out all nil values, "unwrap" the optional values
        removeAllChildren()
        
        // Display background card layout on the screen
        Game.forEachLocation {
            let card = self.createCard(false)
            self.cardBackgrounds[Game.Location(x: $0.x, y: $0.y)] = card
            let x = self.viewWidth * CGFloat($0.x) / CGFloat(Game.widthInCards) + self.cardSize / 2 + self.margin
            let y = self.viewHeight * CGFloat($0.y) / CGFloat(Game.heightInCards) + self.cardSize / 2 + self.margin
            card.position = CGPoint(x: x, y: y)
            self.addChild(card)
        }
        
        Game.forEachLocation { location in
            let value = self.game.valueForLocation(location)
            if value != 0 {
                let backgroundCard = self.cardBackgrounds[location]!
                let card = self.createCard(true, points: self.game.valueForLocation(location))
                self.removeCard(location)
                card.position = backgroundCard.position
                let label = self.createLabel(String(value))
                card.addChild(label)
                self.addCard(location, card: card)
            }
        }
    }
    
    func createCard(frontCard: Bool, points: Int = 0) -> SKSpriteNode {
        if frontCard {
            return SKSpriteNode(color: backgroundColorFromPoints(points), size: CGSize(width: cardSize, height: cardSize))
        } else {
            return SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2), size: CGSize(width: cardSize, height: cardSize))
        }
    }
    
    func backgroundColorFromPoints(points: Int = 0) -> UIColor {
        switch points {
        case points where points < 0:
            return UIColor(red: 34/255, green: 49/255, blue: 63/255, alpha: 1)
        case 0:
            return UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1)
        case 8:
            return UIColor(red: 1, green: 206/255, blue: 96/255, alpha: 1)
        case 16:
            return UIColor(red: 229/255, green: 163/255, blue: 14/255, alpha: 1)
        case 32:
            return UIColor(red: 235/255, green: 149/255, blue: 50/255, alpha: 1)
        case 64:
            return UIColor(red: 207/255, green: 192/255, blue: 73/255, alpha: 1)
        case 128:
            return UIColor(red: 165/255, green: 192/255, blue: 87/255, alpha: 1)
        case 256:
            return UIColor(red: 122/255, green: 193/255, blue: 101/255, alpha: 1)
        case 512:
            return UIColor(red: 80/255, green: 193/255, blue: 115/255, alpha: 1)
        case 1024:
            return UIColor(red: 38/255, green: 194/255, blue: 129/255, alpha: 1)
        case points where points >= 2048:
            return UIColor(red: 65/255, green: 131/255, blue: 215/255, alpha: 1)
        default:
            return UIColor(red: 1, green: 219/255, blue: 138/255, alpha: 1)
        }
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
    
    func moveCard(from: Game.Location, to: Game.Location) {
        if let card = cards[to] {
            removeChildrenInArray([card])
        }
        
        if let card = cards[from] {
            cards.removeValueForKey(from)
            cards[to] = card
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
        if shouldAllowSwiping {
            game.swipeLeft()
        }
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        if shouldAllowSwiping {
            game.swipeRight()
        }
    }
    
    func swipedUp(sender: UISwipeGestureRecognizer) {
        if shouldAllowSwiping {
            game.swipeUp()
        }
    }
    
    func swipedDown(sender: UISwipeGestureRecognizer) {
        if shouldAllowSwiping {
            game.swipeDown()
        }
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
    
    func turnEnded(game: Game) {
        if gameUpdated {
            gameUpdated = false
            if let available = game.randomLocation {
                game.addRandomValue(available)
            }
        } else if game.isGameOver {
            gameOver(game)
        }
    }
    
    func newCardWasAdded(game: Game, location: Game.Location, value: Int) {
        guard let backgroundCard = cardBackgrounds[location] else {
            createBoard()
            return newCardWasAdded(game, location: location, value: value)
        }
        
        
        let card = createCard(true, points: value)
        card.position = backgroundCard.position
        let label = createLabel(String(value))
        card.addChild(label)
        card.alpha = 0
        addCard(location, card: card)
        let action = SKAction.sequence([
            SKAction.fadeInWithDuration(0.2),
            SKAction.scaleTo(1.1, duration: 0.15),
            SKAction.scaleTo(1, duration: 0.15)])
        card.runAction(action)
    }
    
    func cardsDidMerge(from: Game.Location, to: Game.Location, oldValue: Int, newValue: Int) {
        guard let backgroundCardTo = cardBackgrounds[to] else {
            return debugPrint("Background card at \(to) unavailable")
        }
        
        guard let backgroundCardFrom = cardBackgrounds[from] else {
            return debugPrint("Background card at \(from) unavailable")
        }
        
        let card = cards[from] ?? createCard(true, points: newValue)
        card.position = backgroundCardFrom.position
        moveCard(from, to: to)
        let label = createLabel(String(newValue))
        card.removeAllChildren()
        card.addChild(label)
        card.color = backgroundColorFromPoints(newValue)
        gameUpdated = true
        var actionList = [SKAction.moveTo(backgroundCardTo.position, duration: 0.15)]
        
        if newValue == 0 {
            actionList.append(SKAction.scaleTo(0, duration: 0.2))
            actionList.append(SKAction.removeFromParent())
        }
        
        card.runAction(SKAction.sequence(actionList))
    }
    
    func gameOver(game: Game) {
        viewController.didLoseGame(game)
        shouldAllowSwiping = false
    }
}

protocol GameSceneDelegate {
    func didLoseGame(game: Game)
}
