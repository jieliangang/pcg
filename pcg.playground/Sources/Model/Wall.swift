import Foundation
import UIKit

enum WallLocation {
    case top, bottom
}

class Wall: Observable, MovingObject {
    var initialPos = 0

    var observers = [ObjectIdentifier: Observation]()
    var objectType = MovingObjectType.wall
    
    var xPos = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }
    var yPos = 0
    
    var path: Path
    var top = true
    
    init(top: Bool) {
        self.path = Path()
        self.top = top
    }
    
    init(path: Path, top: Bool) {
        self.path = path
        self.top = top
    }
    
    var height = 0
    
    var width: Int {
        return path.length
    }
    
    var lastPoint: Point {
        return path.lastPoint
    }
    
    func update(speed: Int) {
        xPos -= speed
    }
}
