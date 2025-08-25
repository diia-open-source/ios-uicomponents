
import UIKit
import DiiaCommonTypes

public struct DSTableBlockOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableBlockOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockItemModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableBlocksView()
        view.configure(model: [model], eventHandler: eventHandler)
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: insets))
        return box
    }
    
    private enum Constants {
        static let defaultPaddings = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        static let smallPaddings = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}

extension DSTableBlockOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableBlockItemModel(
            tableMainHeadingMlc: .mock,
            tableSecondaryHeadingMlc: .mock,
            items: [
                .init(
                    tableItemVerticalMlc: .mock,
                    tableItemHorizontalMlc: .mock,
                    tableItemPrimaryMlc: DSTableItemPrimaryMlc(label: "label", value: "value", icon: .mock),
                    docTableItemHorizontalMlc: .mock,
                    docTableItemHorizontalLongerMlc: .mock,
                    tableItemHorizontalLargeMlc: .mock,
                    smallEmojiPanelMlc: DSSmallEmojiPanelMlcl(label: "label", icon: .mock)
                )
            ],
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
