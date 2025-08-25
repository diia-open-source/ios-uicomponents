
import Foundation

public struct DSLinkQrShareModel: Codable {
    public let componentId: String
    public let centerChipBlackTabsOrg: DSCenterChipBlackTabsOrgModel?
    public let linkSharingOrg: DSLinkSharingOrgModel?
    public let qrCodeOrg: DSQrCodeOrgModel?
    public let paginationMessageMlc: DSPaginationMessageMlcModel?
    
    public init(
        componentId: String,
        centerChipBlackTabsOrg: DSCenterChipBlackTabsOrgModel?,
        linkSharingOrg: DSLinkSharingOrgModel?,
        qrCodeOrg: DSQrCodeOrgModel?,
        paginationMessageMlc: DSPaginationMessageMlcModel?
    ) {
        self.componentId = componentId
        self.centerChipBlackTabsOrg = centerChipBlackTabsOrg
        self.linkSharingOrg = linkSharingOrg
        self.qrCodeOrg = qrCodeOrg
        self.paginationMessageMlc = paginationMessageMlc
    }
}
