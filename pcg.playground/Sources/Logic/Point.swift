import Foundation

struct Point {
    var xVal: Int
    var yVal: Int
    var grad: Double = 0.0
    
    func gradient(with point: Point) -> Double {
        return Double(point.yVal - self.yVal) / Double(point.xVal - self.xVal)
    }

    init(xVal: Int, yVal: Int) {
        self.xVal = xVal
        self.yVal = yVal
    }

    init(xVal: Int, yVal: Int, grad: Double) {
        self.xVal = xVal
        self.yVal = yVal
        self.grad = grad
    }
}
