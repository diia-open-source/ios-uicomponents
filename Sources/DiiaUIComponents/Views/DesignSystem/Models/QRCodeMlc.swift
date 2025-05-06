
import Foundation

public struct QRCodeMlc: Codable {
    public let qrLink: String
    public let componentId: String?
    
    public init(qrLink: String, componentId: String? = nil) {
        self.qrLink = qrLink
        self.componentId = componentId
    }
}
