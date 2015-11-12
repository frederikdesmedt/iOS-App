import UIKit
import Foundation

struct Game {
    
    typealias Location = (x: Int, y: Int)
    
    static let widthInCards = 4
    static let heightInCards = widthInCards // rectangle
    
    var matrix: [[Int]] = [[Int]](count: Game.widthInCards, repeatedValue: Array(count: Game.heightInCards, repeatedValue: 0))
    private var available = [(x: Int, y: Int)]()
    
    init() {
        Game.forEachLocation {
            self.available.append($0)
        }
    }
    
    init(withRandomValueCount: Int) {
        self.init()
        for _ in 0..<withRandomValueCount {
            if let randomLocation = getRandomLocation() {
                addRandomValue(randomLocation)
            }
        }
    }
    
    mutating func addRandomValue(location: Location) {
        matrix[location.x][location.y] = drand48() <= 0.7 ? 2 : 4
            
        // Remove all available locations pointing to the current location (should be only one)
        available = available.filter { $0.x != location.x || $0.y != location.y }
    }
    
    func getRandomLocation() -> Location? {
        if available.isEmpty {
            return nil;
        }
        
        var index: UInt32 = 0
        arc4random_buf(&index, sizeof(UInt32))
        let location = available[Int(index) % available.count]
        return location
    }
    
    static func forEachLocation(consumer: Location -> Void) {
        for x in 0..<Game.widthInCards {
            for y in 0..<Game.heightInCards {
                consumer((x, y))
            }
        }
    }
}