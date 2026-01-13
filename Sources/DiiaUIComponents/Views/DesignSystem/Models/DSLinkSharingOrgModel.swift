
import DiiaCommonTypes

/// design_system_code: linkSharingOrg
public struct DSLinkSharingOrgModel: Codable {
    public let componentId: String
    public let text: String?
    public let linkSharingMlc: DSLinkSharingMlcModel?
    public let description: String?
    public let btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc?
    public let paginationMessageMlc: DSPaginationMessageMlcModel?
}

public class DSLinkSharingOrgViewModel {
    public enum State {
        case link(DSLinkSharingOrgModel)
        case loading
        case error(DSPaginationMessageMlcModel)
    }

    public let state: Observable<State>

    public init(model: DSLinkSharingOrgModel?) {
        if let model {
            self.state = .init(value: .link(model))
        } else {
            self.state = .init(value: .loading)
        }
    }
}
