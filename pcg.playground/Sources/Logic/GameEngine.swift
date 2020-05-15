import Foundation

public class GameEngine {
    private var gameModel: GameModel
    private var generator: MainGenerator
    
    private var inGameTime = 0
    private var currentStageTime = 0 {
        didSet {
            if currentStageTime >= Constants.stageWidth {
                gameBegin = true
                // Get walls of new stage
                let set = generator.getNext()
                gameModel.movingObjects.append(set.topWall)
                gameModel.movingObjects.append(set.bottomWall)
                currentStageTime = 0
            }
        }
    }

    private var speed = Constants.glideVelocity
    private var normalSpeed = Constants.glideVelocity
    
    private var gameBegin = false
    
    private var timer: Timer?
    
    init(_ model: GameModel, seed: UInt64) {
        // Initialise generator
        generator = MainGenerator(model, seed: seed)
        
        gameModel = model
        
        initSpeed(type: model.type)
        
        startTimer()
    }
    
    /// Initialise in game speed
    /// - Parameters:
    ///     - type: `CharacterType` describes player control type in game
    private func initSpeed(type: PlayerType) {
        switch type {
        case .arrow: normalSpeed = Constants.arrowVelocity
        case .flappy: normalSpeed = Constants.flappyVelocity
        case.glide: normalSpeed = Constants.glideVelocity
        }
        speed = normalSpeed
        generator.speed = normalSpeed
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: Constants.fps, target: self,
                                     selector: #selector(updateGame), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }

    @objc private func updateGame() {
        checkObjectsToGenerate()
        updatePositionsAndTime()
    }
    
    /// Update positions of all moving objects and distance in `GameModel`, and in game time.
    private func updatePositionsAndTime() {
        updateGameObjects(speed: speed)
        gameModel.distance += Int(speed / 10)

        inGameTime += speed
        currentStageTime += speed
    }
    
    /// Update positions of all moving objects in `GameModel`
    private func updateGameObjects(speed: Int) {
        for object in gameModel.movingObjects {
            switch object.objectType {
            case .movingObstacle:
                object.update(speed: speed * 2)
            default:
                object.update(speed: speed)
            }
        }
        // Remove objects that are out of screen
        gameModel.movingObjects = gameModel.movingObjects.filter {
            $0.xPos > -$0.width - 600
        }
    }
    
    /// Generate moving objects in game from generator
    private func checkObjectsToGenerate() {
        guard gameBegin else {
            return
        }
        // Get all objects from generator to be added
        while let object = generator.checkAndGetObject(position: inGameTime) {
            gameModel.movingObjects.append(object)
        }
    }
}


