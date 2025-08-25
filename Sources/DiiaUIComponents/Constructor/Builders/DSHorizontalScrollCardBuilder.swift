
import UIKit
import DiiaCommonTypes

///// design_system_code: cardHorizontalScrollOrg
public struct DSHorizontalScrollCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "cardHorizontalScrollOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSHorizontalScrollCardData = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSHorizontalScrollCardView()
        view.configure(with: model, eventHandler: eventHandler)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}

extension DSHorizontalScrollCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let listGroup1 = DSListGroup(
            title: "Group 1",
            componentId: "componentId",
            items: [
                DSListGroupItem(
                    id: "item1",
                    logoLeft: nil,
                    iconLeft: DSIconModel.mock,
                    bigIconLeft: nil,
                    leftLogoLink: nil,
                    iconRight: DSIconModel.mock,
                    label: "Item 1",
                    state: .enabled,
                    description: "First item description",
                    amountAtm: nil,
                    chipStatusAtm: nil,
                    action: DSActionParameter.mock,
                    dataJson: nil,
                    accessibilityDescription: nil
                )
            ],
            btnPlainIconAtm: DSBtnPlainIconModel(
                id: "btn1",
                state: .enabled,
                label: "Action 1",
                icon: "home",
                action: DSActionParameter.mock,
                componentId: "componentId"
            )
        )
        let listGroup2 = DSListGroup(
            title: "Group 2",
            componentId: "componentId",
            items: [
                DSListGroupItem(
                    id: "item2",
                    logoLeft: nil,
                    iconLeft: nil,
                    bigIconLeft: nil,
                    leftLogoLink: nil,
                    iconRight: nil,
                    label: "Item 2",
                    state: .enabled,
                    description: "Second item description",
                    amountAtm: nil,
                    chipStatusAtm: nil,
                    action: nil,
                    dataJson: nil,
                    accessibilityDescription: nil
                )
            ],
            btnPlainIconAtm: nil
        )
        
        let model = DSHorizontalScrollCardData(
            componentId: "componentId",
            cardsGroup: [listGroup1, listGroup2]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
