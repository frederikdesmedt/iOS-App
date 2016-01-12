import RealmSwift

class HighscoreRepository {
    
    let realm = try? Realm()
    
    var highscores: [Highscore] {
        let dbResult = realm?.objects(Highscore)
        var result = [Highscore]()
        dbResult?.forEach {
            result.append($0)
        }
        
        return result
    }
    
    func save(highscore: Highscore) {
        realm?.beginWrite()
        realm?.add(highscore)
        try! realm?.commitWrite()
    }
}