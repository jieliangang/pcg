import Foundation

/**
`GameModel` contains all the present game objects to be rendered,
as well as in game information to be recoded.
*/

class GameModel: Observable {
    public var observers = [ObjectIdentifier: Observation]()
    public var player: Player
    
    public var speed = Constants.velocity
    public var distance = 0
    
    public var time = 0.0
    public var type: PlayerType
    
    var movingObjects = [MovingObject]() {
        didSet {
            notifyObservers(name: "moving", object: nil)
        }
    }
    
    init(type playerType: PlayerType) {
        player = Player(type: playerType)
        type = playerType
    }
}
