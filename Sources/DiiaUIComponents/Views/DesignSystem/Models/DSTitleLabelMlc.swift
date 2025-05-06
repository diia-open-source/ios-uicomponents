
import Foundation

public struct DSTitleLabelMlc: Codable, Equatable {
    public let label: String
    public let componentId: String?

    public init(label: String, componentId: String?) {
        self.label = label
        self.componentId = componentId
    }
}
