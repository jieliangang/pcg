import Foundation

struct GameParameters {
    var type: PlayerType
    var generator: SeededGenerator

    // Difficulty
    var difficulty = 1

    //Path Generation
    var switchProb = 0.3
    var interval = Constants.pathInterval

    // Wall Generation
    var topWallMin = 500
    var topWallMax = 500
    var botWallMin = -500
    var botWallMax = -500
    var width = 600
    var minWidth: Int
    var diff = 100

    // Obstacle Generation
    var obstacleMinInterval = 300
    var obstacleMaxInterval = 900
    var obstacleOffset = 150
    var obstacleMinOffset = 50
    var movingProb: Float = 0.0
    var obstacleGenerated = true

    // Power Up Generation
    var nextPowerUpMinInterval = 3000
    var nextPowerUpMaxInterval = 7000

    init(_ type: PlayerType, seed: UInt64) {
        self.type = type
        self.generator = SeededGenerator(seed: seed)
        switch type {
        case .arrow:
            interval = Constants.pathMaxInterval
            width = 500
            minWidth = 200

            topWallMin = width/2
            topWallMax = width/2
            botWallMin = -width/2
            botWallMax = -width/2

            obstacleMinOffset = 100

        case .flappy:
            width = 700
            minWidth = 500

            topWallMin = width/2
            topWallMax = width/2
            botWallMin = -width/2
            botWallMax = -width/2

            obstacleMinOffset = 100

        case .glide:
            width = 500
            minWidth = 300
            topWallMin = width/2
            topWallMax = width/2
            botWallMin = -width/2
            botWallMax = -width/2

            obstacleMinOffset = 200
        }
    }

    mutating func nextStage() {
        topWallMin = (width/2) + Int.random(in: (-width/4)...(width/4), using: &generator)
        topWallMax = topWallMin + diff
        botWallMax = -(width - topWallMin)
        botWallMin = botWallMax - diff

        width = max(width - 10, minWidth)

        difficulty += 1
        if difficulty > 6 {
            movingProb = 0.3
        }
        obstacleOffset = max(obstacleOffset - 4, obstacleMinOffset)
    }
}
