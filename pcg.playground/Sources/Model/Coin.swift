import Foundation

/**
 Represents a coin model object in the game
 */
class Coin: Observable, MovingObject {
    var initialPos = 0
    var objectType: MovingObjectType = .coin

    var observers = [ObjectIdentifier: Observation]()

    var xPos: Int = Constants.gameWidth {
        didSet {
            notifyObservers(name: "xPos", object: self)
        }
    }

    var yPos: Int

    var width: Int = Constants.coinSize
    var height: Int = Constants.coinSize

    init(yPos: Int) {
        self.yPos = yPos - Constants.coinSize / 2
    }

    func update(speed: Int) {
        xPos -= speed
    }
}
