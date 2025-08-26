
import Foundation

public protocol UIComponentsLogger {
    func log(_ items: Any...)
}

public func log(_ items: Any...) {
    UIComponentsConfiguration.shared.logger?.log(items)
}
