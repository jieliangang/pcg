import Foundation

import Foundation
import UIKit

/**
 Represents a obstacle model in the game
 */
class Obstacle: Observable, MovingObject {
    var initialPos = 0

    var observers = [ObjectIdentifier: Observation]()
    var objectType = MovingObjectType.obstacle

    var xPos: Int = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int
    var height: Int

    init(yPos: Int, width: Int, height: Int, objectType: MovingObjectType) {
        self.yPos = yPos
        self.width = width
        self.height = height
        self.objectType = objectType
    }

    func update(speed: Int) {
        xPos -= speed
    }
}

