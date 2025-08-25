
import Foundation
import UIKit
import DiiaCommonTypes

/// design_system_code: centerChipBlackTabsOrg
public struct DSCenterChipBlackTabsOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "centerChipBlackTabsOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSCenterChipBlackTabsOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSCenterChipBlackTabsOrgView()
        let itemsViewModels: [DSChipBlackMlcViewModel] = data.items.compactMap { chip in
            let chipViewModel = DSChipBlackMlcViewModel(
                componentId: chip.chipBlackMlc.componentId,
                label:  chip.chipBlackMlc.label,
                code: chip.chipBlackMlc.code,
                action: chip.chipBlackMlc.action
            )

            if chip.chipBlackMlc.code == data.preselectedCode {
                chipViewModel.state.value = .selected
            }

            return chipViewModel
        }

        let groupViewModel = DSCenterChipBlackTabsOrgViewModel(
            componentId: data.componentId,
            preselectedCode: data.preselectedCode,
            itemsViewModels: itemsViewModels
        )

        view.configure(with: groupViewModel, eventHandler: eventHandler)

        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}

extension DSCenterChipBlackTabsOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCenterChipBlackTabsOrgModel(
            componentId: "componentId",
            items: [
                DSChipBlackMlcItemModel(
                    chipBlackMlc: DSChipBlackMlcModel(
                        componentId: "componentId",
                        label: "Home",
                        code: "home_tab",
                        active: false,
                        action: DSActionParameter(
                            type: "tab",
                            subtype: "home",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        )
                    )
                ),
                DSChipBlackMlcItemModel(
                    chipBlackMlc: DSChipBlackMlcModel(
                        componentId: "componentId",
                        label: "Info",
                        code: "info_tab",
                        active: false,
                        action: DSActionParameter(
                            type: "tab",
                            subtype: "info",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        )
                    )
                )
            ],
            preselectedCode: "docs_tab"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
