
import UIKit

protocol GameDelegate {
    // A new card was added to the board
    func newCardWasAdded(game: Game, location: Game.Location, value: Int)
    
    // Two cards are merging due to a swipe and equal values
    func cardsDidMerge(from: Game.Location, to: Game.Location, oldValue: Int, newValue: Int)
    
    // Game ended (due to game over or manual quit)
    func gameOver(game: Game)
    
    // Turn ended (allows dependents to do turn-based actions and logic)
    func turnEnded(game: Game)
}