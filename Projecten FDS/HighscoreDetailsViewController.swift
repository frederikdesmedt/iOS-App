import UIKit
import SpriteKit

class HighscoreDetailsViewController: UIViewController {
    
    var highscore: Highscore!
    var gameScene: GameScene!
    @IBOutlet var gameView: SKView!
    
    override func viewDidLoad() {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.gameView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            scene.game = GameSnapshot.gameFromSnapshot(highscore.game!)
            skView.presentScene(scene)
            gameScene = scene
        }
    }
}