import Foundation
import UIKit
import SpriteKit



public class PlayerNode: SKSpriteNode, Observer {
    var controller: PlayerController?
    var playerId: String?
    
    convenience init(_ player: Player) {
        let size = CGSize(width: 55, height: 55)
        self.init(texture: Constants.arrow,color: SKColor.black, size: size)
        
        switch player.type {
        case .arrow:
            controller = ArrowController(playerNode: self)
        case .glide:
            controller = GlideController(playerNode: self)
        case .flappy:
            controller = FlappyController(playerNode: self)
        }        
        player.addObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    public func onValueChanged(name: String, object: Any?) {
        
    }
    
    public func step() {
        controller?.move()
        updateParticle()
    }
    
    private func updateParticle() {
        guard let velocity = physicsBody?.velocity.dy else {
            return
        }
        let angle = atan(Double(velocity) / Double(Constants.velocity * 60))
        self.zRotation = CGFloat(angle)
    }
}
