import Foundation

public class Action {
    public var type: ActionType
    
    init(type: ActionType) {
        self.type = type
    }
}

public enum ActionType: String, CaseIterable {
    case hold
    case release
    case start
}
