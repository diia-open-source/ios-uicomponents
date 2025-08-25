
import Foundation

/// design_system_code: centerChipBlackTabsOrg
public struct DSCenterChipBlackTabsOrgModel: Codable {
    public let componentId: String
    public let items: [DSChipBlackMlcItemModel]
    public let preselectedCode: String

    public init(componentId: String, items: [DSChipBlackMlcItemModel], preselectedCode: String) {
        self.componentId = componentId
        self.items = items
        self.preselectedCode = preselectedCode
    }
}

public class DSCenterChipBlackTabsOrgViewModel {
    public let componentId: String?
    public let preselectedCode: String
    public let itemsViewModels: [DSChipBlackMlcViewModel]

    public init(componentId: String?,
                preselectedCode: String,
                itemsViewModels: [DSChipBlackMlcViewModel]) {
        self.componentId = componentId
        self.preselectedCode = preselectedCode
        self.itemsViewModels = itemsViewModels
    }

    public func setSelected(chipViewModel: DSChipBlackMlcViewModel) {
        itemsViewModels.forEach { $0.state.value = .unselected }

        if chipViewModel.state.value == .selected {
            chipViewModel.state.value = .unselected
        } else if chipViewModel.state.value == .unselected {
            chipViewModel.state.value = .selected
        }
    }
}
