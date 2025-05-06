
import Foundation

public struct BarCodeMlc: Codable {
    public let barCode: String
    public let componentId: String?
    
    public init(barCode: String, componentId: String? = nil) {
        self.barCode = barCode
        self.componentId = componentId
    }
}
