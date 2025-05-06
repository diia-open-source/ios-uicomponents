
import Foundation

public struct DSAttentionIconMessageMlc: Codable {
    public let componentId: String?
    public let smallIconAtm: DSIconModel
    public let text: String
    public let backgroundMode: DSAttentionIconBackgroundMode
    
    public init(componentId: String? = nil, smallIconAtm: DSIconModel, text: String, backgroundMode: DSAttentionIconBackgroundMode) {
        self.componentId = componentId
        self.smallIconAtm = smallIconAtm
        self.text = text
        self.backgroundMode = backgroundMode
    }
}

public enum DSAttentionIconBackgroundMode: String, Codable {
    case info
    
    public var color: Int {
        switch self {
        case .info: 0xFAF7BA
        }
    }
}
