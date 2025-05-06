

import Foundation

public struct DSSmallCheckIconOrgModel: Codable {
    public let id: String?
    public let inputCode: String?
    public let componentId: String?
    public let title: String?
    public let items: [SmallCheckIconItem]
}

public struct SmallCheckIconItem: Codable {
    public let smallCheckIconMlc: DSSmallCheckIconMlcModel
}


public struct DSSmallCheckIconMlcModel: Codable {
    public let componentId: String?
    public let code: String
    public let icon: DSTickerType
    public let label: String?
    public let state: DSSmallCheckIconMlcState?
}

public enum DSSmallCheckIconMlcState: String, Codable {
    case selected
    case rest
}
