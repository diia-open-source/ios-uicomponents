
import UIKit
import DiiaCommonTypes

/// design_system_code: mapChipTabsOrg
public struct DSMapChipTabsViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "mapChipTabsOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSMapChipGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        
        let insets = padding.defaultCollectionPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
    
    func makeView(data: DSMapChipGroupOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSMapChipTabsView()
        
        let items: [DSMapChipItem] = data.items.compactMap {
            guard let mapChipMlc = $0.mapChipMlc else { return nil }
            
            let isSelected = data.preselectedCode == mapChipMlc.code
           
            return DSMapChipItem(
                code: mapChipMlc.code,
                label: mapChipMlc.label,
                icon: mapChipMlc.icon,
                componentId: mapChipMlc.componentId,
                accessibilityDescription: mapChipMlc.accessibilityDescription,
                isSelected: isSelected
            )
        }
        
        let viewModel = DSMapChipTabViewModel(items: items) { selectedMapChip in
            eventHandler(.action(.init(
                type: self.modelKey,
                resource: selectedMapChip.code)))
        }
        
        view.configure(viewModel: viewModel)
        
        return view
    }
}

// MARK: - Mock
extension DSMapChipTabsViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSMapChipGroupOrg(
            componentId: "componentId",
            label: "label",
            preselectedCode: "preselectedCode",
            items: [
                DSMapChipGroupItem(
                    mapChipMlc: DSMapChipMlc(
                        componentId: "componentId",
                        label: "chip1",
                        icon: "icon",
                        accessibilityDescription: "accessibilityDescription",
                        code: "code"
                    ),
                    btnWhiteAdditionalIconAtm: DSButtonWhiteAdditionalIconAtm(
                        id: "id",
                        state: .enabled,
                        label: "label",
                        icon: "icon",
                        accessibilityDescription: "accessibilityDescription",
                        badgeCounterAtm: DSBadgeCounterModel(count: 1),
                        action: .mock,
                        componentId: "componentId"
                    )
                ),
                DSMapChipGroupItem(
                    mapChipMlc: DSMapChipMlc(
                        componentId: "componentId",
                        label: "chip2",
                        icon: "icon",
                        accessibilityDescription: "accessibilityDescription",
                        code: "code"
                    ),
                    btnWhiteAdditionalIconAtm: DSButtonWhiteAdditionalIconAtm(
                        id: "id",
                        state: .disabled,
                        label: "label",
                        icon: "icon",
                        accessibilityDescription: "accessibilityDescription",
                        badgeCounterAtm: DSBadgeCounterModel(count: 1),
                        action: .mock,
                        componentId: "componentId"
                    )
                )
            ]
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
