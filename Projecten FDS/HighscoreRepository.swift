import RealmSwift

class HighscoreRepository {
    
    let realm = try? Realm()
    
    var highscores: [Highscore] {
        let dbResult = realm?.objects(Highscore)
        
        let result = dbResult?.map {$0}
        
        return result ?? []
    }
    
    func save(highscore: Highscore) {
        realm?.beginWrite()
        realm?.add(highscore)
        _ = try? realm?.commitWrite()
    }
}