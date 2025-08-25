
import Foundation
import UIKit
import DiiaCommonTypes

public struct DSChipsBlackOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "chipBlackGroupOrg"
    
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
        guard let data: DSChipBlackGroupModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSChipBlackGroupOrgView()
        let items: [DSChipBlackMlcViewModel] = data.items.compactMap { chip in
            let chipBlackVm = DSChipBlackMlcViewModel(
                componentId: chip.chipBlackMlc.componentId,
                label:  chip.chipBlackMlc.label,
                code: chip.chipBlackMlc.code,
                action: chip.chipBlackMlc.action
            )

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
        
        groupViewModel.onClick = { [weak groupViewModel] action in
            if let action {
                eventHandler(action)
            } else if let groupViewModel {
                let selectedItems = groupViewModel.selectedItems()
                eventHandler(.inputChanged(.init(
                    inputCode: data.inputCode ?? self.modelKey,
                    inputData: .array(selectedItems.map { .string($0.code) }))))
            }
        }
        view.configure(with: groupViewModel, eventHandler: eventHandler)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        return BoxView(subview: view).withConstraints(insets: insets)
    }
}

extension DSChipsBlackOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let chipItem1 = DSChipBlackMlcItemModel(chipBlackMlc: DSChipBlackMlcModel(
            componentId: "componentId",
            label: "Chip 1",
            code: "chip1",
            active: true,
            action: DSActionParameter.mock
        ))
        let chipItem2 = DSChipBlackMlcItemModel(chipBlackMlc: DSChipBlackMlcModel(
            componentId: "componentId",
            label: "Chip 2",
            code: "chip2",
            active: true,
            action: nil
        ))
        
        let model = DSChipBlackGroupModel(
            componentId: "componentId",
            id: "group1",
            inputCode: "chipGroup",
            mandatory: false,
            label: "Select Options",
            minCount: 1,
            maxCount: 3,
            items: [chipItem1, chipItem2],
            preselectedCodes: ["chip1"]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

