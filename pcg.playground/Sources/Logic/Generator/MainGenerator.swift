import Foundation

struct WallSet {
    var path: Path
    var topWall: Wall
    var bottomWall: Wall
}

/*
 `MainGenerator` handles generation of in-game objects.
 */
class MainGenerator {
    // Generator
    private let pathGenerator: PathGenerator
    private let wallGenerator: WallGenerator
    private var gameGenerator: SeededGenerator
    private let obstacleGenerator: ObstacleGenerator
    private let coinGenerator: CoinGenerator
    
    // Information for Path and Wall Generation
    private var pathEndPoint = Point(xVal: 0, yVal: 0)
    private var topWallEndY = Constants.gameHeight
    private var bottomWallEndY = 0
    private var path = Path()
    private var topWall = Wall(top: true)
    private var bottomWall = Wall(top: false)
    
    // Current Stage Path and Wall for Obstacle and Collectible Calculation and Generation
    private var currentPath = Path()
    private var currentTopWall = Wall(top: true)
    private var currentBottomWall = Wall(top: false)

    // Object Generation Position
    private var currentObstaclePosition = Constants.stageWidth
    private var currentCoinPosition = Constants.stageWidth
    private var pathMax = Constants.stageWidth
    
     var speed = Constants.glideVelocity
    private var parameters: GameParameters
    
    /// Contains `WallSet` for five stages
     private var queue = Queue<WallSet>()

     // Contains all objects queued to be generated, in order of time to be generated
     private var movingObjects = MovingObjectQueue(min: true)
    
    init(_ model: GameModel, seed: UInt64) {
        pathGenerator = PathGenerator(seed)
        pathGenerator.smoothing = !(model.type == .arrow)
        wallGenerator = WallGenerator(seed)
        obstacleGenerator = ObstacleGenerator(seed)
        gameGenerator = SeededGenerator(seed: seed)
        coinGenerator = CoinGenerator(seed)
        parameters = GameParameters(model.type, seed: seed)
    }
    /// Returns next `WallSet`, called when reached next stage
    func getNext() -> WallSet {
        updateParams()
        
        if queue.isEmpty {
            addToQueue()
        } else {
            DispatchQueue.global().async {
                self.addToQueue()
            }
        }
        guard let set = queue.dequeue() else {
            fatalError()
        }
        parameters.nextStage()
        
        currentPath = set.path
        currentTopWall = set.topWall
        currentBottomWall = set.bottomWall
        
        DispatchQueue.global().async {
            self.initStageObjectQueue()
        }

        return set
    }
    
    /// Returns `MovingObject` if position is valid to be generated,
    /// when in game position of `GameEngine` is larger than the `MovingObject` position
    /// - Parameters:
    ///     - position: In game position of `GameEngine`
    func checkAndGetObject(position: Int) -> MovingObject? {
        guard let first = movingObjects.peek() else {
            return nil
        }
        guard position >= first.initialPos else {
            return nil
        }
        // Add new game object to queue when one is retrieved.
        DispatchQueue.global().async {
            switch first.objectType {
            case .coin:
                self.addCoin()
//            case .movingObstacle, .obstacle:
//                self.addObstacle()
            default:
                break
            }
        }
        return movingObjects.poll()
    }


    /// Initialise wall queue by adding five `WallSet`
    private func initWallQueue() {
        for _ in 0..<5 {
            addToQueue()
        }
    }
    
    /// Insert new obstacle, coin and power up at new stage
    private func initStageObjectQueue() {
        for _ in 0..<2 {
            addObstacle()
            addCoin()
        }
    }

    /// Generate new path, and then new top and bottom walls into `WallSet` queue
    private func addToQueue() {
        // First step: Generate new path based on parameters
        let generatedPath = pathGenerator.generateModel(startingPt: pathEndPoint, startingGrad: 0.0,
                                                        prob: parameters.switchProb,
                                                        range: Constants.stageWidth)

        // Second step: Generate walls based on path generated
        let generatedTopWall = Wall(path: wallGenerator.generateTopWallModel(path: generatedPath,
                                                                             startingY: topWallEndY,
                                                                             minRange: parameters.topWallMin,
                                                                             maxRange: parameters.topWallMax),
                                    top: true)
        let generatedBottomWall = Wall(path: wallGenerator.generateBottomWallModel(path: generatedPath,
                                                                                   startingY: bottomWallEndY,
                                                                                   minRange: parameters.botWallMin,
                                                                                   maxRange: parameters.botWallMax),
                                       top: false)

        // Third step: Update parameters to set up subsequent path and wall generation
        path = generatedPath
        topWall = generatedTopWall
        bottomWall = generatedBottomWall
        pathEndPoint = Point(xVal: 0, yVal: path.lastPoint.yVal)
        topWallEndY = topWall.lastPoint.yVal
        bottomWallEndY = bottomWall.lastPoint.yVal

        // Fourth step: Enqueue generated walls to be retrieved by game engine
        queue.enqueue(WallSet(path: path, topWall: topWall, bottomWall: bottomWall))
    }
    
    private func addObstacle() {
        let position = currentObstaclePosition + Int.random(in: 20...50) * speed
        guard position < pathMax else {
            return
        }
        currentObstaclePosition = position

        generateObstacle(position: currentObstaclePosition)
    }

    private func generateObstacle(position: Int) {
        let set = WallSet(path: currentPath, topWall: currentTopWall, bottomWall: currentTopWall)
        let obstacle = obstacleGenerator.generateNextObstacle(xPos: position % Constants.stageWidth,
                                                              wallSet: set, width: parameters.obstacleOffset,
                                                              movingProb: parameters.movingProb)

        guard let validObstacle = obstacle else {
            print("fail")
            return
        }
        validObstacle.initialPos = position
        movingObjects.add(validObstacle)
    }
    
    private func addCoin() {
        let prob = Int.random(in: 0...100)
        let position = prob > 55 ? currentCoinPosition + speed * 8 : currentCoinPosition + speed * 40
        guard position < pathMax else {
            return
        }
        currentCoinPosition = position

        generateCoin(position: currentCoinPosition)
    }

    private func generateCoin(position: Int) {
        let coin = coinGenerator.generateCoin(xPos: position % Constants.stageWidth, path: currentPath)
        coin.initialPos = position
        movingObjects.add(coin)
    }
    
    /// Update generation parameters when setting new stage
    private func updateParams() {
        currentObstaclePosition = pathMax
        currentCoinPosition = pathMax
        pathMax += Constants.stageWidth
    }

}
