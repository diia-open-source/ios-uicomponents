import Foundation

public struct DSActionParameter: Codable, Equatable {
    public let type: String
    public let subtype: String?
    public let resource: String?
    public let subresource: String?

    public init(type: String,
                subtype: String? = nil,
                resource: String? = nil,
                subresource: String? = nil) {
        self.type = type
        self.subtype = subtype
        self.resource = resource
        self.subresource = subresource
    }
}
