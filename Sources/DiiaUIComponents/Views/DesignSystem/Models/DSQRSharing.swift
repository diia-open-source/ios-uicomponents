
import Foundation

///design_system_code: qrSharingOrg

public struct DSQRSharingOrg: Codable {
    public let expireLabel: QRExpireObjectLabel?
    public let qrLink: String
    public let btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc?
    public let stubMessageMlc: DSStubMessageMlc?
    public let componentId: String?
    
    public init(componentId: String?,
                expireLabel: QRExpireObjectLabel?,
                qrLink: String,
                btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc?,
                stubMessageMlc: DSStubMessageMlc?) {
        self.componentId = componentId
        self.expireLabel = expireLabel
        self.qrLink = qrLink
        self.btnIconPlainGroupMlc = btnIconPlainGroupMlc
        self.stubMessageMlc = stubMessageMlc
    }
}

public struct QRExpireObjectLabel: Codable {
    public let text: String
    public let parameters: [QRExpireObjectParameters]?
    
    public init(text: String,
         parameters: [QRExpireObjectParameters]? = nil) {
        self.text = text
        self.parameters = parameters
    }
}

public struct QRExpireObjectParameters: Codable {
    public let type: QRSharingType
    public let data: QRSharingParameterData
    
    public init(type: QRSharingType, data: QRSharingParameterData) {
        self.type = type
        self.data = data
    }
}

public enum QRSharingType: Codable {
    case link, phone, email, timerTime
}

public struct QRSharingParameterData: Codable {
    public let name: String
    public let alt: String?
    public let resource: String?
    public let timerTime: Int?
    
    public init(name: String, alt: String? = nil, resource: String? = nil, timerTime: Int? = nil) {
        self.name = name
        self.alt = alt
        self.resource = resource
        self.timerTime = timerTime
    }
}
