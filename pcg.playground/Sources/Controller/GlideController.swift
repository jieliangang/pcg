import Foundation
import SpriteKit

class GlideController: PlayerController {
    
    weak var playerNode: PlayerNode?
    var isHolding = false
    
    public init(playerNode: PlayerNode) {
//        let texture = SKTexture(imageNamed: "arrow3.png")
//        let playerSize = CGSize(width: 55, height: 55)
        let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(20))
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.mass = 0.1
        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        print(physicsBody.affectedByGravity)
        
        playerNode.physicsBody = physicsBody
        self.playerNode = playerNode
    }
    
    public func move() {
        guard isHolding else {
            return
        }
        glideUp()
    }

    private func glideUp() {
        guard let physicsBody = playerNode?.physicsBody else {
            return
        }
        physicsBody.applyForce(CGVector(dx: 0, dy: 370))
        let velocity = physicsBody.velocity
        if velocity.dy > CGFloat(700) {
            physicsBody.velocity.dy = 700
        } else if velocity.dy < CGFloat(-700) {
            physicsBody.velocity.dy = -700
        }
    }
}
