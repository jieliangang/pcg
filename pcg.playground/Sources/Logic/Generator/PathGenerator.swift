import UIKit
import GameplayKit

/// Player state within path which mimics player control
enum PathState: String {
    case up
    case down
    case stay
    case smooth
}

/**
 `PathGenerator` handles generation of `Path`
 */
class PathGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    // Maximum and minimum path y value
    let topCap = Constants.pathTopCap
    let botCap = Constants.pathBotCap

    // Smoothing parameters. Smooth is done to shape our a quadratic curve.
    var smoothing = false
    let smoothGradientTopCap = 0.8
    let smoothGradientBotCap = 0.4
    var topSmoothCap = Constants.pathTopSmoothCap
    var botSmoothCap = Constants.pathBotSmoothCap
    var interval = Constants.pathInterval

    // Probability of hovering at the same y value and switching actions/state.
    var stayProbability = 0.2
    private var switchProb = 85

    // Maximum gradient of Path
    var gradMax = 4.0
    let gradDiff = 0.1
    var currentState: PathState = .up

    /// Generate path model based on path required parameters
    /// - Parameters:
    ///     - startingPt: first point of the path
    ///     - startingGrad: initial gradient of the path
    ///     - prob: probability of switching controls/direction (hold, release)
    ///     - range: length of Path
    func generateModel(startingPt: Point, startingGrad: Double, prob: Double, range: Int) -> Path {
        switchProb = Int(prob * 100.0)

        var path = Path()
        path.append(point: startingPt)

        var currentX = startingPt.xVal
        var currentY = startingPt.yVal
        var currentGrad = startingPt.grad
        let endX = currentX + range

        while currentX < endX {
            let nextPoint: Point
            if smoothing {
                let nextState = decideState(currentY: currentY, currentGradient: currentGrad,
                                            currentState: currentState)
                nextPoint = generateNextPoint(currX: currentX, currY: currentY, currGrad: currentGrad,
                                                  currState: nextState, endX: endX)
                currentGrad = nextPoint.grad
                currentState = nextState
            } else {
                nextPoint = generateNextArrowPoint(currX: currentX, currY: currentY,
                                                   currState: currentState, endX: endX)
                currentState = (currentState == .up) ? .down: .up
            }
            currentX = nextPoint.xVal
            currentY = nextPoint.yVal
            path.append(point: nextPoint)
        }
        path.length = range

        return path
    }

    /// Decide and generate next point within the trajectory path without smoothening
    /// - Parameters:
    ///     - currX: current point x position
    ///     - currY: current point y position
    ///     - currState: current state
    ///     - endX: last possible x position within path
    private func generateNextArrowPoint(currX: Int, currY: Int, currState: PathState, endX: Int) -> Point {
        var grad = 1.0
        var maxX = currX + Constants.pathMaxInterval
        switch currState {
        case .down:
            grad = 1.0
            maxX = currX + Int((Double(topCap - currY))/grad)
        case .up:
            grad = -1.0
            maxX = currX + Int((Double(botCap - currY))/grad)
        default:
            break
        }
        
        let minX = (currX + interval) > maxX ? currX : (currX + interval)
        let nextX = min(Int.random(in: minX...maxX), endX)
        let nextY = currY + Int(grad * Double(nextX - currX))
        return Point(xVal: nextX, yVal: nextY)
    }

    /// Decide and generate next point within the trajectory path with physics property in mind
    /// - Parameters:
    ///     - currX: current point x position
    ///     - currY: current point y position
    ///     - currGrad: current gradient
    ///     - currState: current state
    ///     - endX: last possible x position within path
    private func generateNextPoint(currX: Int, currY: Int, currGrad: Double, currState: PathState, endX: Int) -> Point {
        var grad = currGrad

        switch currState {
        // Adjust gradient to 0 to smoothen out curve trajectories when accelerating/decelerating
        case .smooth:
            if currGrad > 0 {
                grad = max(grad - gradDiff, 0)
            } else if currGrad < 0 {
                grad = min(grad + gradDiff, 0)
            }
        // Accelerate upwards (hold)
        case .up:
            grad = min(grad + gradDiff, gradMax)
        // Accelerate downwards (release)
        case .down:
            grad = max(grad - gradDiff, -gradMax)
        // Hover at same y position
        case .stay:
            grad = 0.0
        }

        let nextX = min(currX + interval, endX)
        var nextY = currY + Int(grad * Double(nextX - currX))
        if nextY > topCap {
            nextY = topCap
        } else if nextY < botCap {
            nextY = botCap
        }
        return Point(xVal: nextX, yVal: nextY, grad: grad)
    }

    /// Decides next PathState based on current state and switching probability
    /// - Parameters:
    ///     - currentY: current Y position in path
    ///     - currentGradient: current gradient within path
    ///     - currentState: current state within path
    private func decideState(currentY: Int, currentGradient: Double, currentState: PathState) -> PathState {
        let val = Int.random(in: 0...100)
        switch currentState {
        case .up:
            // Do not go further up once reach top limit
            if currentY >= topCap {
                return .stay
            }
            // If moving or accelerating upwards at certain top limit, slow down to prevent
            // character from crashing top limit when decelerating
            if currentY >= topSmoothCap && currentGradient > smoothGradientTopCap {
                return .smooth
            }
            // Either continue going up (holding) or release (smooth)
            return val > switchProb ? .up : .smooth
        case .down:
            // Do not go further down once reach bottom limit
            if currentY <= botCap {
                return .stay
            }
            // If moving or accelerating downwards at certain bottom limit, slow down to prevent
            // character from crashing bottom limit when accelerating upwards
            if currentY <= botSmoothCap && currentGradient < -smoothGradientTopCap {
                return .smooth
            }
            // Either continue going down (releasing) or hold (smooth)
            return val > switchProb ? .down : .smooth
        case .stay:
            // Maintain at same position
            // Conflicts when hovering upwards and downwards is addressed by path width
            if val < Int(stayProbability * 100) {
                return .stay
            }
            // If at extreme ends, go down or up accordingly.
            else if currentY > Constants.pathTopSmoothCap {
                return .down
            } else if currentY < Constants.pathBotSmoothCap {
                return .up
            }
            // Go up or down
            else {
                return val < Int((1-stayProbability)*100)/2 ? .up : .down
            }
        case .smooth:
            // Continue smoothing
            if currentGradient > smoothGradientBotCap || currentGradient < -smoothGradientBotCap {
                return .smooth
            } else if currentY > Constants.pathTopSmoothCap {
                return .down
            } else if currentY < Constants.pathBotSmoothCap {
                return .up
            }
            // Finish smoothing. Proceed to stay.
            else {
                return val < 50 ? .up : .down
            }
        }
    }

    func makePath(arr: [Point]) -> UIBezierPath {
        return UIBezierPath(points: arr)
    }
}
