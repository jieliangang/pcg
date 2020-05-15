import Foundation
import UIKit

/**
 `WallGenerator` handles generation of `Wall`
 */
class WallGenerator {

    var generator: SeededGenerator

    init(_ seed: UInt64) {
        generator = SeededGenerator(seed: seed)
    }

    /// Generate top wall based on path
    /// - Parameters:
    ///     - path: `Path` to be refered for wall generation
    ///     - startingY: starting y for first `Point` in `Path` for continuation from previous path
    ///     - minRange: minimum distance between wall and path
    ///     - maxRange: maximum distance between wall and path
    func generateTopWallModel(path: Path, startingY: Int, minRange: Int, maxRange: Int) -> Path {
        // return path
        return generateNoise(path: path, range: minRange...maxRange, startingY: startingY)
    }

    /// Generate bottom wall based on path
    /// - Parameters:
    ///     - path: `Path` to be refered for wall generation
    ///     - startingY: starting y for first `Point` in `Path` for continuation from previous path
    ///     - minRange: minimum distance between wall and path
    ///     - maxRange: maximum distance between wall and path
    func generateBottomWallModel(path: Path, startingY: Int, minRange: Int, maxRange: Int) -> Path {
        return generateNoise(path: path, range: (minRange)...(maxRange), startingY: startingY)
    }

    func generateTopBound(path: Path, startingY: Int, by shift: Int) -> Path {
        return path.shift(by: shift)
    }

    func generateBottomBound(path: Path, startingY: Int, by shift: Int) -> Path {
        return path.shift(by: -shift)
    }

    func makePath(path: Path) -> UIBezierPath {
        return path.generateBezierPath()
    }

    /// Generate noise in a path to generate rock-like appearance,
    /// while adhering to range restriction between Wall and Path
    private func generateNoise(path: Path, range: ClosedRange<Int>, startingY: Int) -> Path {
        let points = path.points

        var noisePoints = points.map {
            shiftPoint(point: $0, by: range)
        }
        noisePoints[0] = Point(xVal: noisePoints[0].xVal, yVal: startingY)

        return Path(points: noisePoints, length: path.length)
    }

    /// Shift a point upwards or downwards. Capped by screen height.
    private func shiftPoint(point: Point, by range: ClosedRange<Int>) -> Point {
        var yVal = point.yVal + Int.random(in: range)
        if yVal < Constants.bottomBound {
            yVal = Constants.bottomBound - 30
        } else if yVal > Constants.topBound {
            yVal = Constants.topBound + 30
        }
        return Point(xVal: point.xVal, yVal: yVal)
    }
}
