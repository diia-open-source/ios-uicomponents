import Foundation

public struct DSActionParameter: Codable {
    public let type: String
    public let subtype: String?
    public let resource: String?

    public init(type: String,
                subtype: String? = nil,
                resource: String? = nil) {
        self.type = type
        self.subtype = subtype
        self.resource = resource
    }
}
