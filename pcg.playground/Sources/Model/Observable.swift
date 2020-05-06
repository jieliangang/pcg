import Foundation

public protocol Observable: class {
    var observers: [ObjectIdentifier: Observation] { get set }
    
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func notifyObservers(name: String, object: Any?)
}

extension Observable {
    public func addObserver(_ observer: Observer) {
        let oid = ObjectIdentifier(observer)
        observers[oid] = Observation(observer: observer)
    }
    public func removeObserver(_ observer: Observer) {
        let oid = ObjectIdentifier(observer)
        observers.removeValue(forKey: oid)
    }
    public func notifyObservers(name: String, object: Any?) {
        for (_, observation) in observers {
            observation.observer?.onValueChanged(name: name, object: object)
        }
    }
}

public struct Observation {
    weak var observer: Observer?
}

