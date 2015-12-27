//
//  GameViewController.swift
//  Projecten FDS
//
//  Created by Frederik De Smedt on 5/11/15.
//  Copyright (c) 2015 Frederik De Smedt. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var nextGame: Game?
    var delegate: GameViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            if let nextGame = nextGame {
                scene.game = nextGame
                self.nextGame = nil
            }
            
            skView.presentScene(scene)
            gameScene = scene
        }
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if (!(parent?.isEqual(self.parentViewController) ?? false)) {
            didPauseGame()
        }
    }
    
    override func viewWillLayoutSubviews() {
        gameScene.createBoard()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didPauseGame() {
        if let delegate = delegate {
            delegate.didPauseGame(gameScene.game)
        }
    }
}
