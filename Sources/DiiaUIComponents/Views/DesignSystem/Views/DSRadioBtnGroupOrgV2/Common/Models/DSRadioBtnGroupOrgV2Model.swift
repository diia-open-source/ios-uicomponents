
import Foundation

public struct DSRadioBtnGroupOrgV2Model: Codable {
    public let componentId: String
    public let inputCode: String?
    public let mandatory: Bool?
    public let title: String?
    public let items: [DSRadioGroupItemV2]
    public let btnPlainIconAtm: DSBtnPlainIconModel?
    
    public init(componentId: String, inputCode: String?, mandatory: Bool?, title: String?, items: [DSRadioGroupItemV2], btnPlainIconAtm: DSBtnPlainIconModel?) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.mandatory = mandatory
        self.title = title
        self.items = items
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}
