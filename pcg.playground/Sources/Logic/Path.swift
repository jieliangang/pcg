import Foundation
import UIKit

/**
 A `Path` describes a continuous trajectory connected point by one,
 and is represented by an array of Point objects.
 
 Representation Invariant:
    1) A path must be continuous to the right.
 */
struct Path {
    var points = [Point]()
    var minY = Constants.gameHeight
    var length = 0

    init() {
        points = [Point]()
    }

    init(points: [Point], length: Int) {
        self.points = points
        self.length = length
    }

    /// Returns number of points in `Path`
    var count: Int {
        return points.count
    }

    /// Returns last Point in `Path`
    var lastPoint: Point {
        guard let last = points.last else {
            return Point(xVal: 0, yVal: Constants.gameHeight / 2)
        }
        return last
    }

    /// Adds new point to end of `Path`
    /// - Parameters:
    ///     - xVal: x value of new `Point`
    ///     - yVal: y value of new `Point`
    mutating func append(xVal: Int, yVal: Int) {
        let point = Point(xVal: xVal, yVal: yVal)
        points.append(point)
        minY = min(minY, yVal)
    }

    /// Adds new point to end of `Path`
    /// - Parameters:
    ///     - point: new `Point` to added to `Path`
    mutating func append(point: Point) {
        points.append(point)
        minY = min(minY, point.yVal)
    }

    /// Generates a `UIBezierPath` based on `Path`
    func generateBezierPath() -> UIBezierPath {
        return UIBezierPath(points: points)
    }

    /// Translates path upwards or downwards
    /// - Parameters:
    ///     - amount: magnitude of translation
    func shift(by amount: Int) -> Path {
        let shiftedPoints = points.map {
            return Point(xVal: $0.xVal, yVal: $0.yVal + amount)
        }
        return Path(points: shiftedPoints, length: length)
    }

    /// Returns y value of estimated `Point` in `Path` at a x position
    /// Complexity: O(N)
    /// - Parameters:
    ///     - xVal: x position of `Point` to be estimated and calculated
    func getPointAt(xVal: Int) -> Int {
        guard count > 2 else {
            return 0
        }
        var index = 1
        // Get upper bound `Point`
        // Can be optimised with binary search
        while index < count && points[index].xVal < xVal {
            index += 1
        }
        let leftPt = points[index - 1]
        let rightPt = points[index]
        let gradient = leftPt.gradient(with: rightPt)
        let yVal = Int(gradient * Double(xVal - leftPt.xVal)) + leftPt.yVal

        return yVal
    }

    /// Return all `Point` within a range of x values
    /// Complexity: O(N)
    /// - Parameters:
    ///     - fromVal: start of range
    ///     - toVal  : end of range
    func getAllPointsFrom(from fromVal: Int, to toVal: Int) -> [Point] {
        var result = [Point]()

        guard count >= 2 else {
            return result
        }
        guard fromVal >= 0 else {
            return result
        }

        // Get start point
        var index = 1
        while index < count && points[index].xVal <= fromVal {
            index += 1
        }
        var leftPt = points[index - 1]
        var rightPt = points[index]
        var gradient = leftPt.gradient(with: rightPt)
        var yVal = Int(gradient * Double(fromVal - leftPt.xVal)) + leftPt.yVal
        let startingPt = Point(xVal: fromVal, yVal: yVal)
        result.append(startingPt)

        // Get middle point
        while index < count && points[index].xVal <= toVal {
            result.append(points[index])
            index += 1
        }
        guard index < count else {
            return result
        }

        // Get final point
        leftPt = points[index - 1]
        rightPt = points[index]
        gradient = leftPt.gradient(with: rightPt)
        yVal = Int(gradient * Double(toVal - leftPt.xVal)) + leftPt.yVal
        let endingPt = Point(xVal: toVal, yVal: yVal)
        result.append(endingPt)

        return result
    }

    /// Close path to form a wall.
    /// The first and last point are extend to form a closed shape for wall generation.
    /// - Parameters:
    ///     - top: Indicates if path formed is for top `Wall` or bottom `Wall`
    mutating func close(top: Bool) -> Path {
        guard count > 0 else {
            return Path()
        }
        var newPoints = points
        let cap = Constants.gameHeight/2 + 50
        let yVal = top ? cap : -cap
        newPoints[0].xVal = points[0].xVal - 5
        newPoints.insert(Point(xVal: points[0].xVal - 5, yVal: yVal), at: 0)
        newPoints.append(Point(xVal: points[count-1].xVal, yVal: yVal))
        return Path(points: newPoints, length: length)
    }

    private func checkRep() -> Bool {
        for index in 0..<(points.count - 1)
            where points[index].xVal > points[index+1].xVal {
                return false
        }
        return true
    }
}
