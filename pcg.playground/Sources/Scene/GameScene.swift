import Foundation
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerNode: PlayerNode!
    var backgroundNode: SKNode!
    
    var gameModel: GameModel!
    var gameEngine: GameEngine!
    
    // Mapping of Model to Node
    var movingObjects: [ObjectIdentifier: SKNode] = [:]
    
    var playerType = PlayerType.glide
    
    var seed = Int.random(in: 0...999999999)
    
    public override func didMove(to view: SKView) {
        // init
        initGameModel(type: playerType)
        initGameEngine(seed: UInt64(seed))
        initPlayer()
        
        initBackground(type: playerType)
        initBoundary()
        
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
    
    func initGameModel(type playerType: PlayerType) {
        gameModel = GameModel(type: playerType)
        gameModel.addObserver(self)
    }
    
    func initGameEngine(seed: UInt64) {
        gameEngine = GameEngine(gameModel, seed: seed)
    }
    
    func initPlayer() {
        playerNode = PlayerNode(gameModel.player)
        playerNode.position = CGPoint(x: CGFloat(Constants.playerOriginX), y: 0)
        self.addChild(playerNode)
    }
    
    func initBackground(type: PlayerType) {
        backgroundNode = BackgroundNode(self.frame, type: type)
        self.addChild(backgroundNode)
    }
    
    func initBoundary() {
        let topBoundary = BoundaryNode(CGFloat(Constants.gameHeight/2 + 20))
        let bottomBoundary = BoundaryNode(CGFloat(-Constants.gameHeight/2 - 20))
        self.addChild(topBoundary)
        self.addChild(bottomBoundary)
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


extension GameScene: Observer {
    public func onValueChanged(name: String, object: Any?) {
        switch name {
        case "moving":
            for object in gameModel.movingObjects where movingObjects[ObjectIdentifier(object)] == nil {
                let node: SKNode
                guard let wall = object as? Wall else {
                    continue
                }
                node = WallNode(wall: wall)
                movingObjects[ObjectIdentifier(wall)] = node
                self.addChild(node)
            }
            // Remove nodes not in gameModel
            let oids = gameModel.movingObjects.map { ObjectIdentifier($0) }
            for oid in movingObjects.keys where !oids.contains(oid) {
                guard let node = movingObjects[oid] else {
                    continue
                }
                node.removeFromParent()
                movingObjects.removeValue(forKey: oid)
            }
        default:
            break
        }
    }
}
