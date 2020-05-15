import Foundation

enum MovingObjectType {
    case obstacle, powerup, wall, movingObstacle, coin
}

protocol MovingObject: class {
    var xPos: Int { get set }
    var yPos: Int { get set }
    var width: Int { get }
    var height: Int { get }
    var objectType: MovingObjectType { get }
    var initialPos: Int { get set }

    func update(speed: Int)
}
