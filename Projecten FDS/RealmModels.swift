import RealmSwift

class Highscore: Object {
    
    dynamic var game: GameSnapshot?
    dynamic var player: String?

}

class GameSnapshot: Object {
    
    dynamic var score: Int = 0
    dynamic var cards: String = ""
    
    static func snapshotFrom(game: Game) -> GameSnapshot {
        let snapshot = GameSnapshot()
        snapshot.score = game.score
        game.matrix.forEach {
            row in row.forEach {
                snapshot.cards += $0.description
            }
        }
        return snapshot
    }
}