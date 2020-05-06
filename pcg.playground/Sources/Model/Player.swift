import Foundation

public enum PlayerType: String {
    case arrow, glide, flappy
}

public class Player: Observable {
    public var observers = [ObjectIdentifier: Observation]()
    public var type: PlayerType
    
    init(type: PlayerType) {
        self.type = type
    }
}
