import Foundation
import SpriteKit

class FlappyController: PlayerController {
    
    weak var playerNode: PlayerNode?
    
    var isHolding = false
    private var wasHolding = false
    var direction = Direction.goUp
    
    public init(playerNode: PlayerNode) {
        let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(20))
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.mass = 0.1
        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        
        physicsBody.categoryBitMask = ColliderType.player.rawValue
        physicsBody.contactTestBitMask = ColliderType.wall.rawValue | ColliderType.obstacle.rawValue
            | ColliderType.coin.rawValue | ColliderType.boundary.rawValue
        physicsBody.collisionBitMask = 0
        
        playerNode.physicsBody = physicsBody
        self.playerNode = playerNode
    }
    
    public func move() {
        if isHolding && !wasHolding {
            jump()
        }
        wasHolding = isHolding
    }

    private func jump() {
        guard let physicsBody = playerNode?.physicsBody else {
            return
        }
        
        physicsBody.applyImpulse(CGVector(dx: 0, dy: 450))
        let velocity = physicsBody.velocity
        if velocity.dy > CGFloat(900) {
            physicsBody.velocity.dy = 900
        } else if velocity.dy < CGFloat(-900) {
            physicsBody.velocity.dy = -900
        }
    }
}
