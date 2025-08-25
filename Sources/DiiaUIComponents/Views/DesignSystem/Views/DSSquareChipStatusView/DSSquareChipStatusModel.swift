
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
    case blue
    case grey
    
    var backgroundColor: String {
        switch self {
        case .blue: "#A1D9D7"
        case .grey: "#D1D1D1"
        }
    }
    
    var textColor: String {
        return "#000000"
    }
}
