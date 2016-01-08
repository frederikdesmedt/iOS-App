import UIKit

class HighscoreController : UITableViewController {
    
    let highscores: [Highscore] = []
    
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
        cell.detailTextLabel!.text = highscore.game.score.description
        return cell
    }
}