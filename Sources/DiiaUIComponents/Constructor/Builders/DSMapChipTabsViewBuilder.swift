
import UIKit
import DiiaCommonTypes

/// design_system_code: mapChipTabsOrg
public struct DSMapChipTabsViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "mapChipTabsOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSMapChipGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        
        let insets = padding.defaultCollectionPadding()
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
                type: Self.modelKey,
                resource: selectedMapChip.code)))
        }
        
        view.configure(viewModel: viewModel)
        
        return view
    }
}
