import UIKit
import Foundation

class Game {
    
    // No typealias because of mandatory hashable implementation
    // typealias Location = (x: Int, y: Int)
    
    struct Location: CustomStringConvertible {
        var x: Int
        var y: Int
        
        var description: String {
            return "(\(x), \(y))"
        }
        
        func above(location: Location) -> Bool {
            return self.y < location.y
        }
        
        func below(location: Location) -> Bool {
            return self.y > location.y
        }
        
        func leftOf(location: Location) -> Bool {
            return self.x < location.x
        }
        
        func rightOf(location: Location) -> Bool {
            return self.x > location.x
        }
        
        func slideDown() -> Location {
            return Location(x: self.x, y: self.y >= 3 ? 3 : self.y + 1)
        }
        
        func slideUp() -> Location {
            return Location(x: self.x, y: self.y <= 0 ? 0 : self.y - 1)
        }
        
        func slideRight() -> Location {
            return Location(x: self.x >= 3 ? 3 : self.x + 1, y: self.y)
        }
        
        func slideLeft() -> Location {
            return Location(x: self.x <= 0 ? 0 : self.x - 1, y: self.y)
        }
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
    
    func addRandomValue(location: Location) {
        let cardValue = drand48() <= 0.7 ? 2 : 4
        valueForLocation(location, value: cardValue)
        
        // Remove all available locations pointing to the current location (should be only one)
        available = available.filter { $0.x != location.x || $0.y != location.y }
        if let delegate = delegate {
            delegate.newCardWasAdded(location, value: cardValue)
        }
    }
    
    var randomLocation: Location? {
        if available.isEmpty {
            return nil;
        }
        
        var index: UInt16 = 0
        arc4random_buf(&index, sizeof(UInt16))
        let location = available[Int(index) % available.count]
        return location
    }
    
    func valueForLocation(location: Location) -> Int {
        return matrix[location.x][location.y]
    }
    
    func valueForLocation(location: Location, value: Int) {
        matrix[location.x][location.y] = value
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
    var hashValue: Int {
        // assuming that x and y do not go any higher than 2^16 - 1
        return (x << 16) & y
    }
}

extension Game {
    func swipeLeft() {
        for y in 0..<Game.heightInCards {
            var stop = -1
            for x in 0..<Game.widthInCards {
                let location = Location(x: x, y: y)
                let locationValue = valueForLocation(location)
                if locationValue != 0 {
                    for bx in 0..<x {
                        let backLocation = Location(x: bx, y: y)
                        let backLocationValue = valueForLocation(backLocation)
                        if backLocation.x > stop && (backLocationValue == 0 || backLocationValue == locationValue) && isConnected(backLocation, to: location) {
                            available = available.filter { $0 != backLocation }
                            available.append(location)
                            valueForLocation(location, value: 0)
                            valueForLocation(backLocation, value: locationValue + backLocationValue)
                            delegate?.cardsDidMerge(location, to: backLocation, oldValue: locationValue, newValue: locationValue + backLocationValue)
                            if backLocationValue != 0 {
                                stop = backLocation.x
                            }
                            break
                        }
                    }
                }
            }
        }
        
        if let location = self.randomLocation {
            addRandomValue(location)
        }
    }
    
    func swipeRight() {
        for y in 0..<Game.heightInCards {
            var stop = Game.widthInCards
            for x in (Game.widthInCards - 1).stride(through: 0, by: -1) {
                let location = Location(x: x, y: y)
                let locationValue = valueForLocation(location)
                if locationValue != 0 {
                    for bx in (Game.widthInCards - 1).stride(through: x + 1, by: -1) {
                        let backLocation = Location(x: bx, y: y)
                        let backLocationValue = valueForLocation(backLocation)
                        if backLocation.x < stop && (backLocationValue == 0 || backLocationValue == locationValue) && isConnected(location, to: backLocation) {
                            available = available.filter { $0 != backLocation }
                            available.append(location)
                            valueForLocation(location, value: 0)
                            valueForLocation(backLocation, value: locationValue + backLocationValue)
                            delegate?.cardsDidMerge(location, to: backLocation, oldValue: locationValue, newValue: locationValue + backLocationValue)
                            if backLocationValue != 0 {
                                stop = backLocation.x
                            }
                            break
                        }
                    }
                }
            }
        }
        
        if let location = self.randomLocation {
            addRandomValue(location)
        }
    }
    
    func swipeUp() {
        for x in 0..<Game.widthInCards {
            var stop = Game.heightInCards
            for y in 0..<Game.heightInCards {
                let location = Location(x: x, y: y)
                let locationValue = valueForLocation(location)
                if locationValue != 0 {
                    for by in (Game.heightInCards - 1).stride(through: y + 1, by: -1) {
                        let backLocation = Location(x: x, y: by)
                        let backLocationValue = valueForLocation(backLocation)
                        if backLocation.y < stop && (backLocationValue == 0 || backLocationValue == locationValue) && isConnected(location, to: backLocation) {
                            available = available.filter { $0 != backLocation }
                            available.append(location)
                            valueForLocation(location, value: 0)
                            valueForLocation(backLocation, value: locationValue + backLocationValue)
                            delegate?.cardsDidMerge(location, to: backLocation, oldValue: locationValue, newValue: locationValue + backLocationValue)
                            if backLocationValue != 0 {
                                stop = backLocation.y
                            }
                            break
                        }
                    }
                }
            }
        }
        
        if let location = self.randomLocation {
            addRandomValue(location)
        }
    }
    
    func swipeDown() {
        for x in 0..<Game.widthInCards {
            var stop = -1
            for y in (Game.heightInCards - 1).stride(through: 0, by: -1) {
                let location = Location(x: x, y: y)
                let locationValue = valueForLocation(location)
                if locationValue != 0 {
                    for by in 0..<y {
                        let backLocation = Location(x: x, y: by)
                        let backLocationValue = valueForLocation(backLocation)
                        if backLocation.x > stop && (backLocationValue == 0 || backLocationValue == locationValue) && isConnected(backLocation, to: location) {
                            available = available.filter { $0 != backLocation }
                            available.append(location)
                            valueForLocation(location, value: 0)
                            valueForLocation(backLocation, value: locationValue + backLocationValue)
                            delegate?.cardsDidMerge(location, to: backLocation, oldValue: locationValue, newValue: locationValue + backLocationValue)
                            if backLocationValue != 0 {
                                stop = backLocation.x
                            }
                            break
                        }
                    }
                }
            }
        }
        
        if let location = self.randomLocation {
            addRandomValue(location)
        }
    }
    
    /// Two locations are connected if they have the same x or y and there are only 0's in between
    func isConnected(from: Location, to: Location) -> Bool {
        if from.x == to.x {
            var temp = from
            for _ in 0..<(to.y - from.y - 1) {
                temp = temp.slideDown()
                if valueForLocation(temp) != 0 {
                    return false
                }
            }
            
            return true
        } else if from.y == to.y {
            var temp = from
            for _ in 0..<(to.x - from.x - 1) {
                temp = temp.slideRight()
                if valueForLocation(temp) != 0 {
                    return false
                }
            }
            
            return true
        }
        
        return false
    }
}