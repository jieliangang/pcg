import Foundation
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerNode: PlayerNode!
    
    var gameModel: GameModel!
    
    var playerType = PlayerType.arrow
    
    public override func didMove(to view: SKView) {
        // init
        initGameModel(playerType)
        initPlayer()
        
        // Set up physics world
        switch playerType {
        case .arrow:
            physicsWorld.gravity = Constants.arrowGravity
        case .flappy:
            physicsWorld.gravity = Constants.flappyGravity
        case .glide:
            physicsWorld.gravity = Constants.glideGravity
        }
        physicsWorld.contactDelegate = self
    }
    
    func initGameModel(_ playerType: PlayerType) {
        gameModel = GameModel(type: playerType)
    }
    
    func initPlayer() {
        playerNode = PlayerNode(gameModel.player)
        playerNode.position = CGPoint(x: CGFloat(Constants.playerOriginX), y: 0)
        self.addChild(playerNode)
    }
    
    @objc static public override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerNode?.controller?.isHolding = true
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerNode?.controller?.isHolding = false
    }
    

    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        playerNode.step()
    }
}
