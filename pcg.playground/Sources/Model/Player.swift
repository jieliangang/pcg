import Foundation

public class Player: Observable {
    public var observers = [ObjectIdentifier: Observation]()
    
    public var isHolding = false
}
