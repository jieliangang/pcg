import Foundation
import SpriteKit

class ArrowController: PlayerController {
    
    weak var playerNode: PlayerNode?
    
    var isHolding = false
    private var wasHolding = false
    var direction = Direction.goUp
    
    public init(playerNode: PlayerNode) {
//        let texture = SKTexture(imageNamed: "arrow3.png")
//        let playerSize = CGSize(width: 55, height: 55)
        let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(20))
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.mass = 30
        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        print(physicsBody.affectedByGravity)
        
        playerNode.physicsBody = physicsBody
        self.playerNode = playerNode
    }
    
    public func move() {
        if isHolding && !wasHolding {
            switchDirection()
        }
        wasHolding = isHolding
    }

    private func switchDirection() {
        guard let physicsBody = playerNode?.physicsBody else {
            return
        }
        
        switch direction {
        case .goUp:
            direction = .goDown
            physicsBody.velocity = Constants.downwardVelocity
        case .goDown:
            direction = .goUp
            physicsBody.velocity = Constants.upwardVelocity
        }
    }
}

public enum Direction {
    case goUp, goDown
}
