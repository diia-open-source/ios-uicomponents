import Foundation

public struct DSTickerAtom: Codable {
    public let usage: DSTickerUsage
    public let type: DSTickerType
    public let value: String
    public let action: DSActionParameter?
    public let componentId: String?

    public init(usage: DSTickerUsage, type: DSTickerType, value: String, action: DSActionParameter? = nil, componentId: String? = nil) {
        self.usage = usage
        self.type = type
        self.value = value
        self.action = action
        self.componentId = componentId
    }
}

public enum DSTickerUsage: String, Codable {
    case document, stackedCard

    var height: CGFloat {
        switch self {
        case .document:
            return 32
        case .stackedCard:
            return 24
        }
    }
}

public enum DSTickerType: String, Codable {
    case neutral, positive, informative, warning
}
