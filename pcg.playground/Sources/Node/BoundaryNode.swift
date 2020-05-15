import Foundation
import SpriteKit

class BoundaryNode: SKSpriteNode {
    convenience init(_ yPos: CGFloat) {
        self.init(color: UIColor.red, size: CGSize(width: 400, height: 1))
        self.position = CGPoint(x: CGFloat(Constants.playerOriginX), y: yPos)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.boundary.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.boundary.rawValue
        //self.physicsBody?.collisionBitMask = 0
    }
}
