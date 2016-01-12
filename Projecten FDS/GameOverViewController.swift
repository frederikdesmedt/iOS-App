import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var gameOverTextView: UITextField?
    var game: Game!
    let highscoreRepository = HighscoreRepository()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func finish() {
        let highscore = Highscore()
        highscore.game = GameSnapshot.snapshotFrom(game)
        highscore.player = gameOverTextView?.text ?? "Anonymous"
        highscoreRepository.save(highscore)
    }
}