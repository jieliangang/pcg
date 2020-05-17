import UIKit
import SpriteKit

class ObstacleNode: SKSpriteNode, Observer {

    convenience init(obstacle: Obstacle) {
        let texture: SKTexture
        if obstacle.objectType == .obstacle {
            texture = Constants.getObstacleTexture()
        } else {
            texture = Constants.movingObstacle
        }

        self.init(texture: texture, size: CGSize(width: obstacle.width, height: obstacle.height))

        if obstacle.objectType == .movingObstacle {
            if let emitter = SKEmitterNode(fileNamed: "MovingObstacle") {
                emitter.position = self.position
                emitter.zPosition = 0.5
                self.addChild(emitter)
            }
        }

        self.position = CGPoint(x: obstacle.xPos + obstacle.width / 2,
                                y: obstacle.yPos + obstacle.height / 2)

        self.name = "obstacle"
//        self.physicsBody = SKPhysicsBody(texture: texture,
//                                         size: CGSize(width: obstacle.width, height: obstacle.height))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(obstacle.width/2))
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.obstacle.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.player.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.zPosition = 1.0

        obstacle.addObserver(self)
    }

    func onValueChanged(name: String, object: Any?) {
        guard let obstacle = object as? Obstacle else {
            return
        }

        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: obstacle.xPos + obstacle.width / 2,
                                        y: obstacle.yPos + obstacle.height / 2)
            default:
                return
            }
        }
    }
}
