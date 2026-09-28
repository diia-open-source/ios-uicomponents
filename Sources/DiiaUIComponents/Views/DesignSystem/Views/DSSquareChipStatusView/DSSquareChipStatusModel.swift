
import Foundation

public struct DSSquareChipStatusModel: Codable {
    public let componentId: String?
    public let name: String
    public let type: DSSquareChipStatusType
    
    public init(componentId: String? = nil, name: String, type: DSSquareChipStatusType) {
        self.componentId = componentId
        self.name = name
        self.type = type
    }
}

public enum DSSquareChipStatusType: String, Codable {
    case blue, general, new, external, partner, recommended
    
    var backgroundColor: String {
        switch self {
        case .blue: return "#B7ECEF"
        case .general: return "#EEF7F1"
        case .new: return "#B7ECEF"
        case .external: return "#CCE5FF"
        case .partner: return "#DCCCFF"
        case .recommended: return "#000000"
        }
    }
    
    var textColor: String {
        switch self {
        case .blue: return "#075A60"
        case .general: return "#075A60"
        case .new: return "#075A60"
        case .external: return "#073360"
        case .partner: return "#250760"
        case .recommended: return "#FFFFFF"
        }
    }
}
