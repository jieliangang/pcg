import Foundation
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerNode: PlayerNode!
    var backgroundNode: SKNode!
    
    var scoreNode: ScoreNode!
    var coinScoreNode: CoinScoreNode!
    
    var gameModel: GameModel!
    var gameEngine: GameEngine!
    
    // Mapping of Model to Node
    var movingObjects: [ObjectIdentifier: SKNode] = [:]
    
    var playerType = PlayerType.arrow
    
    var seed = Int.random(in: 0...999999999)
    
    public override func didMove(to view: SKView) {
        // init
        initGameModel(type: playerType)
        initGameEngine(seed: UInt64(seed))
        initPlayer()
        
        initScore()
        initCoinScore()
        
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
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let isBodyAObstacle = contact.bodyA.categoryBitMask == ColliderType.obstacle.rawValue
        let isBodyAWall = contact.bodyA.categoryBitMask == ColliderType.wall.rawValue
        let isBodyABoundary = contact.bodyA.categoryBitMask == ColliderType.boundary.rawValue
        let isBodyBObstacle = contact.bodyB.categoryBitMask == ColliderType.obstacle.rawValue
        let isBodyBWall = contact.bodyB.categoryBitMask == ColliderType.wall.rawValue
        let isBodyBBoundary = contact.bodyB.categoryBitMask == ColliderType.boundary.rawValue

        if isBodyAObstacle || isBodyAWall {
            guard let playerNode = contact.bodyB.node as? PlayerNode else {
                return
            }
            playerNode.removeFromParent()
            gameOver()
        } else if isBodyBObstacle || isBodyBWall {
            guard let playerNode = contact.bodyA.node as? PlayerNode else {
                return
            }
            playerNode.removeFromParent()
            gameOver()
        } else if contact.bodyA.categoryBitMask == ColliderType.coin.rawValue {
            guard let node = contact.bodyA.node as? CoinNode else {
                return
            }
            gameModel.coinCount += 1
            node.removeFromParent()
        } else if contact.bodyB.categoryBitMask == ColliderType.coin.rawValue {
            guard let node = contact.bodyB.node as? CoinNode else {
                return
            }
            gameModel.coinCount += 1
            node.removeFromParent()
        } else if isBodyABoundary || isBodyBBoundary {
           //  playerNode.removeFromParent()
            gameOver()
        }
    }
    
    func gameOver() {
        if let gameOverScene = GameOverScene(fileNamed: "GameOverScene") {
            gameOverScene.playerType = playerType
            gameOverScene.score = gameModel.distance
            
            self.view?.presentScene(gameOverScene, transition: SKTransition.fade(with: .white, duration: 0.5))
        }
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
        let topBoundary = BoundaryNode(CGFloat(Constants.gameHeight/2 + 50))
        let bottomBoundary = BoundaryNode(CGFloat(-Constants.gameHeight/2 - 50))
        self.addChild(topBoundary)
        self.addChild(bottomBoundary)
    }
    
    func initScore() {
        scoreNode = ScoreNode()
        scoreNode.position = CGPoint(x: CGFloat(250), y: CGFloat(Constants.gameHeight/2 - 50))
        self.addChild(scoreNode)
    }
    
    func initCoinScore() {
        coinScoreNode = CoinScoreNode()
        coinScoreNode.position = CGPoint(x: CGFloat(250), y: CGFloat(Constants.gameHeight/2 - 80))
        self.addChild(coinScoreNode)
    }
    
    func updateScore() {
        scoreNode.update(gameModel.distance)
        coinScoreNode.update(gameModel.coinCount)
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
        
//        let gameOverScene = GameOverScene(size: self.size)
//        self.view?.presentScene(gameOverScene)
    }
    

    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        playerNode.step()
        updateScore()
    }
}


extension GameScene: Observer {
    public func onValueChanged(name: String, object: Any?) {
        switch name {
        case "moving":
            for object in gameModel.movingObjects where movingObjects[ObjectIdentifier(object)] == nil {
                let node: SKNode
                switch object.objectType {
                case .wall:
                    guard let wall = object as? Wall else {
                        continue
                    }
                    node = WallNode(wall: wall)
                    movingObjects[ObjectIdentifier(wall)] = node
                case .coin:
                    guard let coin = object as? Coin else {
                        continue
                    }
                    node = CoinNode(coin: coin)
                    movingObjects[ObjectIdentifier(coin)] = node
                default:
                    guard let obstacle = object as? Obstacle else {
                        continue
                    }
                    node = ObstacleNode(obstacle: obstacle)
                    movingObjects[ObjectIdentifier(obstacle)] = node
                }
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
