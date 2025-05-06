
import Foundation
import UIKit
import DiiaCommonTypes

public struct DSChipsBlackOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "chipBlackGroupOrg"
    
    private let isActive: Bool

    public init(isActive: Bool = true) {
        self.isActive = isActive
    }
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSChipBlackGroupModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSChipBlackGroupOrgView()
        let items: [DSChipBlackMlcViewModel] = data.items.compactMap { chip in
            let chipBlackVm = DSChipBlackMlcViewModel(componentId: chip.chipBlackMlc.componentId, label:  chip.chipBlackMlc.label, code: chip.chipBlackMlc.code)
            
            if data.preselectedCodes?.contains(chip.chipBlackMlc.code) == true {
                chipBlackVm.state.value = .selected
            }
            
            if let isActive = chip.chipBlackMlc.active, !isActive {
                chipBlackVm.state.value = .disabled
            }
            return chipBlackVm
        }
        let groupViewModel = DSChipBlackGroupViewModel(
            componentId: data.componentId,
            id: data.id,
            inputCode: data.inputCode,
            mandatory: data.mandatory,
            label: data.label,
            minCount: data.minCount,
            maxCount: data.maxCount,
            items: items)
        
        groupViewModel.onClick = { [weak groupViewModel] in
            guard let viewModel = groupViewModel else { return }
            let selectedItems = viewModel.selectedItems()
            eventHandler(.inputChanged(.init(
                inputCode: data.inputCode ?? Self.modelKey,
                inputData: .array(selectedItems.map { .string($0.code) }))))
        }
        view.configure(with: groupViewModel)
        let insets = padding.defaultPadding()
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}

