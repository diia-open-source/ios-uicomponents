
import Foundation

/// design_system_code: alertCardMlcV2
public struct DSAlertCardMlcV2Model: Codable {
    public let iconAtm: DSIconModel?
    public let label: String
    public let text: String?
    public let btnPrimaryAdditionalAtm: DSButtonModel?
    
    public init(icon: DSIconModel?, title: String, subtitle: String?, buttonModel: DSButtonModel?) {
        self.iconAtm = icon
        self.label = title
        self.text = subtitle
        self.btnPrimaryAdditionalAtm = buttonModel
    }
}
