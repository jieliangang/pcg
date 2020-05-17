import Foundation
import UIKit
import SpriteKit

public class PlayerNode: SKSpriteNode, Observer {
    var controller: PlayerController?
    var emitter = SKEmitterNode(fileNamed: "Bokeh")
    
    convenience init(_ player: Player) {
        let size = CGSize(width: Constants.playerSize, height: Constants.playerSize)
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
        
        guard let particleEmitter = emitter else {
            return
        }
        particleEmitter.position = self.position
        particleEmitter.particleSize = CGSize(width: 20, height: 20)
        particleEmitter.zPosition = 1

        particleEmitter.particleColorSequence = nil
        particleEmitter.particleColorBlendFactor = 1.0
        particleEmitter.particleColor = .white

        self.addGlow()
//        self.addChild(particleEmitter)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
        emitter?.emissionAngle = CGFloat(angle + Double.pi)
    }
    
}

extension SKSpriteNode {
    func addGlow(radius: Float = 20) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: Constants.arrow, size: size))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    }
}
