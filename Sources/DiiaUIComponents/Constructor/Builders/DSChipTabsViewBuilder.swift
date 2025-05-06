
import UIKit
import DiiaCommonTypes

/// design_system_code: chipTabsOrg
public struct DSChipTabsViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "chipTabsOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSChipGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        
        let insets = padding.defaultCollectionPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
    
    func makeView(data: DSChipGroupOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSChipTabsView()
        let items: [DSChipItem] = data.items.compactMap {
            guard let chipMlc = $0.chipMlc else { return nil }
            let isSelected = data.preselectedCode == chipMlc.code
            return DSChipItem(
                code: chipMlc.code,
                name: chipMlc.label,
                numCount: chipMlc.badgeCounterAtm?.count,
                isSelected: isSelected,
                action: chipMlc.action)
        }
        let viewModel = DSChipTabViewModel(items: items) { selectedChip in
            if let action = selectedChip.action {
                eventHandler(.action(action))
            } else {
                eventHandler(.action(.init(type: Self.modelKey, resource: selectedChip.code)))
            }
        }
        view.configure(viewModel: viewModel)
        return view
    }
}
