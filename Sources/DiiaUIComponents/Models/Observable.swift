
import Foundation

public final class Observable<T> {
    public typealias GenericClosure = (T) -> Void
    private final class Observation {
        let closure: GenericClosure
        weak var observer: NSObjectProtocol?
        
        init(observer: NSObjectProtocol, closure: @escaping GenericClosure) {
            self.closure = closure
            self.observer = observer
        }
    }
    
    public var value: T {
        didSet {
            observations.forEach { _, observation in
                observation.closure(value)
            }
        }
    }
    
    private var observations = [UUID: Observation]()
    
    public init(value: T) {
        self.value = value
    }
    
    public func observe(observer: NSObjectProtocol, _ closure: @escaping GenericClosure) {
        let id = UUID()
        observations[id] = .init(observer: observer) { [weak self, weak observer] value in
            guard observer != nil else {
                self?.observations.removeValue(forKey: id)
                return
            }
            closure(value)
        }
        closure(value)
    }
    
    public func removeObserver(observer: NSObjectProtocol) {
        let idsToRemove = observations.filter { _, value in
            if let valueObserver = value.observer {
                return valueObserver.isEqual(observer)
            }
            return true
        }.keys
        idsToRemove.forEach { observations.removeValue(forKey: $0) }
    }
}
