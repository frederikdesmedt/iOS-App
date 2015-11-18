import UIKit
import Foundation

struct Game {
    
    // No typealias because of mandatory hashable implementation
    // typealias Location = (x: Int, y: Int)
    
    struct Location {
        var x: Int
        var y: Int
    }
    
    static let widthInCards = 4
    static let heightInCards = widthInCards // rectangle
    
    var matrix: [[Int]] = [[Int]](count: Game.widthInCards, repeatedValue: Array(count: Game.heightInCards, repeatedValue: 0))
    private var available = [Location]()
    var delegate: GameDelegate?
    
    init() {
        Game.forEachLocation {
            self.available.append($0)
        }
    }
    
    mutating func addRandomValue(location: Location) {
        let cardValue = drand48() <= 0.7 ? 2 : 4
        matrix[location.x][location.y] = cardValue
            
        // Remove all available locations pointing to the current location (should be only one)
        available = available.filter { $0.x != location.x || $0.y != location.y }
        if let delegate = delegate {
            delegate.newCardWasAdded(location, value: cardValue)
        }
    }
    
    var randomLocation: Location? {
        get {
            if available.isEmpty {
                return nil;
            }
            
            var index: UInt16 = 0
            arc4random_buf(&index, sizeof(UInt16))
            let location = available[Int(index) % available.count]
            return location
        }
    }
    
    static func forEachLocation(consumer: Location -> Void) {
        for x in 0..<Game.widthInCards {
            for y in 0..<Game.heightInCards {
                consumer(Location(x: x, y: y))
            }
        }
    }
}

func ==(left: Game.Location, right: Game.Location) -> Bool {
    return left.x == right.x && left.y == right.y
}

extension Game.Location: Hashable {
    var hashValue: Int { get {
        // assuming that x and y do not go any higher than 2^16 - 1
            return (x << 16) & y
        }
    }
}