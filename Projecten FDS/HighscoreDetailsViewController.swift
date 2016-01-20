import UIKit
import SpriteKit

class HighscoreDetailsViewController: UIViewController {
    
    var highscore: Highscore?
    var gameScene: GameScene!
    @IBOutlet var gameView: SKView!
    
    override func viewDidLoad() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem()
        }
        
        if let highscore = highscore {
            if let scene = GameScene(fileNamed:"GameScene") {
                let skView = self.gameView
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.ignoresSiblingOrder = true
                scene.highscoreMode = true
                
                let game = GameSnapshot.gameFromSnapshot(highscore.game!)
                game.shouldAddRandomValues = false
                scene.game = game
                scene.shouldAllowSwiping = false
                scene.createBoard(true)
                
                skView.presentScene(scene)
                gameScene = scene
            }
        }
    }
}