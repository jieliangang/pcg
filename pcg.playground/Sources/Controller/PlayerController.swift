import Foundation

public protocol PlayerController {
    var playerNode: PlayerNode? { get set }
    var isHolding: Bool { get set }
    func move()
}
