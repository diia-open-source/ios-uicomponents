import Foundation

class ReflectionObject {
    private let mirror: Mirror
    
    init(reflecting: Any) {
        mirror = Mirror(reflecting: reflecting)
    }
    
    func extractVariable<T>(name: StaticString = #function) -> T? {
        return mirror.descendant("\(name)") as? T
    }
}
