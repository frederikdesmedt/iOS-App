import UIKit

class MainMenuViewController: UIViewController, GameViewControllerDelegate {
    
    var game: Game?
    
    @IBOutlet var continueGameButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        if let _ = game {
            continueGameButton.hidden = false
        } else {
            continueGameButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case "newGame"?:
            let controller = segue.destinationViewController as! GameViewController
            controller.delegate = self
        case "continueGame"?:
            let controller = segue.destinationViewController as! GameViewController
            controller.nextGame = game
            controller.delegate = self
        default:
            return
        }
    }
    
    func didLoseGame() {
        game = nil
    }
    
    func didPauseGame(game: Game) {
        self.game = game
    }
}