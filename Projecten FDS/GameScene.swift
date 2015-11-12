//
//  GameScene.swift
//  Projecten FDS
//
//  Created by Frederik De Smedt on 5/11/15.
//  Copyright (c) 2015 Frederik De Smedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let game = Game(withRandomValueCount: 1)
    
    var cards: [[SKNode!]]!
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        
        initGestureRecognizerForDirection(.Left, action: "swipedLeft:")
        initGestureRecognizerForDirection(.Right, action: "swipedRight:")
        initGestureRecognizerForDirection(.Up, action: "swipedUp:")
        initGestureRecognizerForDirection(.Down, action: "swipedDown:")
        
        // Fill fixed-size cards with nil
        cards = [[SKNode!]](count: Game.widthInCards, repeatedValue: [SKNode!](count: Game.heightInCards, repeatedValue: nil))
        backgroundColor = UIColor(red: 187 / 255, green: 173 / 255, blue: 160 / 255, alpha: 1)
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
        
        // Padding to center board in screen
        let paddingX = min((size.height - size.width) / 2, 0)
        let paddingY = min((size.width - size.height) / 2, 0)
        
        let margin: CGFloat = 5
        
        let cardSize = min(self.viewWidth / CGFloat(Game.widthInCards) - margin * 2, self.viewHeight / CGFloat(Game.heightInCards) - margin * 2)
        
        // Fill cards with actual SKSpriteNodes and display them on the screen
        Game.forEachLocation {
            let card = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2), size: CGSize(width: cardSize, height: cardSize))
            self.cards[$0.x][$0.y] = card
            let x = self.viewWidth * CGFloat($0.x) / CGFloat(Game.widthInCards) + cardSize / 2 + margin - paddingX
            let y = self.viewHeight * CGFloat($0.y) / CGFloat(Game.heightInCards) + cardSize / 2 + margin - paddingY
            card.position = CGPoint(x: x, y: y)
            let label = SKLabelNode(text: "0")
            label.fontName = "AvenirNext"
            label.fontSize = 24
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            card.addChild(label)
            self.addChild(card)
        }
    }
    
    func initGestureRecognizerForDirection(direction: UISwipeGestureRecognizerDirection, action: String) {
        let recognizer = UISwipeGestureRecognizer(target: self, action: Selector(action))
        recognizer.direction = direction
        view!.addGestureRecognizer(recognizer)
    }
    
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //       /* Called when a touch begins */
    //
    //        for touch in touches {
    //            let location = touch.locationInNode(self)
    //
    //            let sprite = SKSpriteNode(imageNamed:"Spaceship")
    //
    //            sprite.xScale = 0.5
    //            sprite.yScale = 0.5
    //            sprite.position = location
    //
    //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
    //
    //            sprite.runAction(SKAction.repeatActionForever(action))
    //
    //            self.addChild(sprite)
    //        }
    //    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        
    }
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        
    }
    
    func swipedUp(sender: UISwipeGestureRecognizer) {
        
    }
    
    func swipedDown(sender: UISwipeGestureRecognizer) {
        
    }
}
