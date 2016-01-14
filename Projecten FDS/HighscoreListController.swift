import UIKit

class HighscoreListViewController : UITableViewController, UISplitViewControllerDelegate {
    
    var highscores: [Highscore]!
    let highscoreRepository = HighscoreRepository()
    var selectedHighscore: Highscore?
    
    override func viewDidLoad() {
        highscores = highscoreRepository.highscores
        splitViewController!.delegate = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highscores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("highscore", forIndexPath: indexPath)
        let highscore = highscores[indexPath.item]
        cell.textLabel!.text = highscore.player ?? "Anonymous"
        cell.detailTextLabel!.text = highscore.game!.score.description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedHighscore = highscores[indexPath.item]
        performSegueWithIdentifier("detail", sender: self)
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let detailController = (segue.destinationViewController as! UINavigationController).topViewController as! HighscoreDetailsViewController
            detailController.highscore = selectedHighscore!
        }
    }
    
    @IBAction func closeHighscores() {
        splitViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}