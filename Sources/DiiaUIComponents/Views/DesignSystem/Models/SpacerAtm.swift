
import DiiaCommonTypes
import Foundation

struct SpacerAtm: Codable {
    var componentId: String?
    var value: SpacerAtmValue
    
    public init(
        componentId: String? = nil,
        value: SpacerAtmValue
    ) {
        self.componentId = componentId
        self.value = value
    }
    
    enum SpacerAtmValue: String, Codable, EnumDecodable {
        static let defaultValue: SpacerAtmValue = .small
        
        case small
        case medium
        case large
        case extraLarge = "extra_large"
        
        var height: CGFloat {
            switch self {
            case .small:
                return 8
            case .medium:
                return 16
            case .large:
                return 24
            case .extraLarge:
                return 32
            }
        }
    }
}
