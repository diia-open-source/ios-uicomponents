
import Foundation

/// design_system_code: listItemGroupOrg
public struct DSListGroup: Codable {
    public let title: String?
    public let componentId: String?
    public let items: [DSListGroupItem]
    public let btnPlainIconAtm: DSBtnPlainIconModel?
    
    public init(
        title: String? = nil, 
        componentId: String? = nil,
        items: [DSListGroupItem],
        btnPlainIconAtm: DSBtnPlainIconModel? = nil) {
        self.title = title
        self.componentId = componentId
        self.items = items
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}

/// design_system_code: listItemMlc
public struct DSListGroupItem: Codable {
    public let id: String?
    public let logoLeft: String?
    public let iconLeft: DSIconModel?
    public let leftLogoLink: String?
    public let bigIconLeft: DSIconModel?
    public let iconRight: DSIconModel?
    public let label: String
    public let state: DSItemListViewState?
    public let description: String?
    public let chipStatusAtm: DSCardStatusChipModel?
    public let amountAtm: DSAmountAtmModel?
    public let action: DSActionParameter?
    public let dataJson: String?
    public let accessibilityDescription: String?
    
    public init(
        id: String? = nil,
        logoLeft: String? = nil,
        iconLeft: DSIconModel? = nil,
        bigIconLeft: DSIconModel? = nil,
        leftLogoLink: String? = nil,
        iconRight: DSIconModel? = nil,
        label: String,
        state: DSItemListViewState? = nil,
        description: String? = nil,
        amountAtm: DSAmountAtmModel? = nil,
        chipStatusAtm: DSCardStatusChipModel? = nil,
        action: DSActionParameter? = nil,
        dataJson: String? = nil,
        accessibilityDescription: String? = nil
    ) {
        self.id = id
        self.logoLeft = logoLeft
        self.iconLeft = iconLeft
        self.bigIconLeft = bigIconLeft
        self.leftLogoLink = leftLogoLink
        self.iconRight = iconRight
        self.label = label
        self.state = state
        self.description = description
        self.action = action
        self.amountAtm = amountAtm
        self.chipStatusAtm = chipStatusAtm
        self.dataJson = dataJson
        self.accessibilityDescription = accessibilityDescription
    }
}

public enum DSItemListViewState: String, Codable {
    case enabled
    case disabled
}
