import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var gameOverTextField: UITextField!
    @IBOutlet weak var gameOverLabel: UILabel!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var game: Game!
    let highscoreRepository = HighscoreRepository()
    
    
    override func viewDidLoad() {
        gameOverLabel.text = "You got a score of \(game.score)!"
        gameOverTextField.text = userDefaults.stringForKey("name") ?? ""
    }
    
    @IBAction func finish() {
        let highscore = Highscore()
        highscore.game = GameSnapshot.snapshotFrom(game)
        
        if let playerName = gameOverTextField.text where playerName != "" {
            highscore.player = playerName
        } else {
            highscore.player = "Anonymous"
        }
        
        highscoreRepository.save(highscore)
        dismissViewControllerAnimated(true, completion: nil)
    }
}