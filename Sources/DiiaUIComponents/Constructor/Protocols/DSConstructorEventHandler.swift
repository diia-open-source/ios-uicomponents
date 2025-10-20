
import Foundation

public protocol DSConstructorEventHandler: NSObjectProtocol {
    func handleEvent(event: ConstructorItemEvent)
}
