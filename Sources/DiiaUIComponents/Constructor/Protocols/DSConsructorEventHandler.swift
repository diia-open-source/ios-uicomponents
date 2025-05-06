
import Foundation

public protocol DSConsructorEventHandler: NSObjectProtocol {
    func handleEvent(event: ConstructorItemEvent)
}
