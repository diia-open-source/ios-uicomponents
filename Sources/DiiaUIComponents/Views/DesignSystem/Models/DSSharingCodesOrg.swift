
import Foundation

public struct DSSharingCodesOrg: Codable {
    public let componentId: String?
    public let expireLabel: DSExpireLabelBox?
    public let qrCodeMlc: QRCodeMlc
    public let btnLoadIconPlainGroupMlc: DSBtnLoadPlainGroupMlc?
    public let stubMessageMlc: DSStubMessageMlc
    
    public init(componentId: String?,
                expireLabel: DSExpireLabelBox?,
                qrCodeMlc: QRCodeMlc,
                btnLoadIconPlainGroupMlc: DSBtnLoadPlainGroupMlc?,
                stubMessageMlc: DSStubMessageMlc) {
        self.componentId = componentId
        self.expireLabel = expireLabel
        self.qrCodeMlc = qrCodeMlc
        self.btnLoadIconPlainGroupMlc = btnLoadIconPlainGroupMlc
        self.stubMessageMlc = stubMessageMlc
    }
}

public struct DSExpireLabelBox: Codable {
    public let expireLabelFirst: String
    public let expireLabelLast: String?
    public let timer: Int
    
    public init(expireLabelFirst: String,
                expireLabelLast: String?,
                timer: Int) {
        self.expireLabelFirst = expireLabelFirst
        self.expireLabelLast = expireLabelLast
        self.timer = timer
    }
}
