import Foundation
import SpriteKit

class WallNode: SKShapeNode, Observer {
    convenience init(wall: Wall) {
        let path = wall.path.close(top: wall.top).generateBezierPath()
        path.close()
        let cgPath = path.cgPath
        self.init(path: cgPath)
        
        self.lineWidth = 6
        self.strokeColor = UIColor.clear
        self.glowWidth = 0
        self.fillColor = UIColor.black
        self.alpha = 0.8
        self.physicsBody?.isDynamic = false
        self.position = CGPoint(x: wall.xPos, y: wall.yPos)

        self.name = "wall"
        let physicsPath = wall.path.generateBezierPath().cgPath
        self.physicsBody = SKPhysicsBody(edgeChainFrom: physicsPath)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.wall.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.player.rawValue
        self.physicsBody?.collisionBitMask = 0
        wall.addObserver(self)
    }
    
    func onValueChanged(name: String, object: Any?) {
        guard let wall = object as? Wall else {
            return
        }
        DispatchQueue.main.async {
            switch name {
            case "xPos":
                self.position = CGPoint(x: wall.xPos, y: wall.yPos)
            default:
                return
            }
        }
    }
}
