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
    
    // Information for Path and Wall Generation
    private var pathEndPoint = Point(xVal: 0, yVal: 0)
    private var topWallEndY = Constants.gameHeight
    private var bottomWallEndY = 0
    private var path = Path()
    private var topWall = Wall(top: true)
    private var bottomWall = Wall(top: false)
    
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
        gameGenerator = SeededGenerator(seed: seed)
        parameters = GameParameters(model.type, seed: seed)
    }
    /// Returns next `WallSet`, called when reached next stage
    func getNext() -> WallSet {

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

        return set
    }


    /// Initialise wall queue by adding five `WallSet`
    private func initWallQueue() {
        for _ in 0..<5 {
            addToQueue()
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
}
