import Foundation

/**
 `ObstacleGenerator` handles generation of `Obstacle`
 */
class ObstacleGenerator {

    var generator: SeededGenerator
    var movingObstacleProb: Float = 0.7

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    /// Generate obstacle based on two bounds and path
    /// - Parameters:
    ///     - xPos: starting position of obstacle
    ///     - topWall: upper Wall in game
    ///     - bottomWall: bottom Wall in game
    ///     - path: Path in game
    ///     - width: width of path
    func generateNextObstacle(xPos: Int, wallSet: WallSet, width: Int,
                              movingProb: Float) -> Obstacle? {
        movingObstacleProb = movingProb
        let num = Float.random(in: (0.0)...(1.0))
        // Decide to place obstacle at upper or lower of path
        if num < 0.5 {
            return generateObstacle(xPos: xPos, topBound: wallSet.topWall.path,
                                    bottomBound: wallSet.path.shift(by: width), top: true)
        } else {
            return generateObstacle(xPos: xPos, topBound: wallSet.path.shift(by: -width),
                                    bottomBound: wallSet.bottomWall.path, top: false)
        }
    }

    private func generateObstacle(xPos: Int, topBound: Path, bottomBound: Path, top: Bool) -> Obstacle? {
        // Determine if stationary or moving obstacle
        let type: MovingObjectType
        let num = Float.random(in: (0.0)...(1.0))
        type = (num < (1.0-movingObstacleProb)) ? .obstacle : .movingObstacle
        let range = (num < 0.8) ? 70 : 50

        // Generate square boundary of obstacle which fits between wall and path
        let topPoints = topBound.getAllPointsFrom(from: xPos, to: min(topBound.length, xPos + range))
        let botPoints = bottomBound.getAllPointsFrom(from: xPos, to: min(bottomBound.length, xPos + range))

        let maxY = topPoints.reduce(Constants.gameHeight) { (result, next) -> Int in
            return min(result, next.yVal)
        }
        let minY = botPoints.reduce(0) { (result, next) -> Int in
            return max(result, next.yVal)
        }
        let candidateY = maxY - minY
        guard candidateY > 30 else {
            return nil
        }

        var size = min(candidateY, range)

        size = (type == .movingObstacle) ? 30 : Int.random(in: 30...size)

        let pos = top ? bottomBound.points[0].yVal : topBound.points[0].yVal - size
        return Obstacle(yPos: pos, width: size, height: size, objectType: type)
    }
}
