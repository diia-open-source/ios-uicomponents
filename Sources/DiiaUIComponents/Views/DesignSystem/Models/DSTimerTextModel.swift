
import Foundation

public struct DSTimerTextModel: Codable {
    public let componentId: String?
    public let expireLabel: DSExpireLabelBox?
    public let stateAfterExpiration: DSTimerTextExpirationModel
    
    public init(
        componentId: String?,
        expireLabel: DSExpireLabelBox?,
        stateAfterExpiration: DSTimerTextExpirationModel
    ) {
        self.componentId = componentId
        self.expireLabel = expireLabel
        self.stateAfterExpiration = stateAfterExpiration
    }
}

public struct DSTimerTextExpirationModel: Codable {
    public let btnLinkAtm: DSButtonModel
    
    public init(btnLinkAtm: DSButtonModel) {
        self.btnLinkAtm = btnLinkAtm
    }
}
