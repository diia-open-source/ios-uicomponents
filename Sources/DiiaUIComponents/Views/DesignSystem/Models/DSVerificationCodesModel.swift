
import Foundation

public struct DSVerificationCodesModel: Codable {
    public let componentId: String?
    public let UA: DSVerificationCodesData?
    public let EN: DSVerificationCodesData?
    
    public init(componentId: String? = nil,
                UA: DSVerificationCodesData? = nil,
                EN: DSVerificationCodesData? = nil) {
        self.componentId = componentId
        self.UA = UA
        self.EN = EN
    }
}

public struct DSVerificationCodesData: Codable {
    public let expireLabel: DSExpireLabelBox?
    public let qrCodeMlc: QRCodeMlc?
    public let barCodeMlc: BarCodeMlc?
    public let toggleButtonGroupOrg: DSToggleButtonGroupModel?
    public let stubMessageMlc: DSStubMessageMlc?
    
    public init(expireLabel: DSExpireLabelBox? = nil,
                qrCodeMlc: QRCodeMlc? = nil,
                barCodeMlc: BarCodeMlc? = nil,
                toggleButtonGroupOrg: DSToggleButtonGroupModel? = nil,
                stubMessageMlc: DSStubMessageMlc? = nil) {
        self.expireLabel = expireLabel
        self.qrCodeMlc = qrCodeMlc
        self.barCodeMlc = barCodeMlc
        self.toggleButtonGroupOrg = toggleButtonGroupOrg
        self.stubMessageMlc = stubMessageMlc
    }
}
