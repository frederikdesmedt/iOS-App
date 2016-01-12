import UIKit

class HighscoreDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem()
    }
}