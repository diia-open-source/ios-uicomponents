
import Foundation
import UIKit
import DiiaCommonTypes

/// design_system_code: centerChipTabsOrg
public struct DSCenterChipTabsOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "centerChipTabsOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSChipGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        
        if let paddingMode = DSPaddingsModel.createFromJSON(object, modelKey: modelKey) {
            (view as? DSPaddingModeDependedViewProtocol)?.setupPaddingMode(paddingMode)
        }
        let insets = padding.defaultCollectionPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
    
    func makeView(data: DSChipGroupOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSCenteredChipTabsView()
        let items: [DSChipItem] = data.items.compactMap {
            guard let chipMlc = $0.chipMlc else { return nil }
            let isSelected = data.preselectedCode == chipMlc.code
            return DSChipItem(
                code: chipMlc.code,
                name: chipMlc.label,
                numCount: chipMlc.badgeCounterAtm?.count,
                iconLeft: chipMlc.iconLeft,
                isSelected: isSelected,
                isSelectable: chipMlc.isSelectable,
                action: chipMlc.action)
        }
        let viewModel = DSChipTabViewModel(items: items) { selectedChip in
            if let action = selectedChip.action {
                eventHandler(.action(action))
            } else {
                eventHandler(.action(.init(type: self.modelKey, resource: selectedChip.code)))
            }
        }
        view.configure(viewModel: viewModel, eventHandler: eventHandler)
        return view
    }
}

extension DSCenterChipTabsOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSChipGroupOrg(
            componentId: "componentId",
            label: "Tab Group",
            preselectedCode: "tab1",
            items: [
                DSChipItemMlc(chipMlc: DSChipMlc(
                    componentId: "componentId",
                    label: "Tab 1",
                    code: "tab1",
                    badgeCounterAtm: DSBadgeCounterModel(count: 3),
                    iconLeft: DSIconModel.mock,
                    active: true,
                    selectedIcon: "home",
                    isSelectable: true,
                    chipInfo: DSChipInfo(hallId: "hall1"),
                    action: DSActionParameter.mock
                )),
                DSChipItemMlc(chipMlc: DSChipMlc(
                    componentId: "componentId",
                    label: "Tab 2",
                    code: "home",
                    badgeCounterAtm: nil,
                    iconLeft: nil,
                    active: true,
                    selectedIcon: nil,
                    isSelectable: true,
                    chipInfo: nil,
                    action: nil
                ))
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
