import Foundation

public protocol Observer: class {
    func onValueChanged(name: String, object: Any?)
}


