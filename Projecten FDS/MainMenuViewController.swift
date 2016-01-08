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
    
    @IBAction func continueGame(element: UIControl) {
        performSegueWithIdentifier("game", sender: element)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "game":
            let controller = segue.destinationViewController as! GameViewController
            controller.nextGame = sender as? UIButton == continueGameButton ? game : nil
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