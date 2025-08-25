
import UIKit
import DiiaCommonTypes

public struct DSTableBlockPlaneOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableBlockPlaneOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockItemModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableBlockPlaneOrgView()
        view.configure(for: model, eventHandler: eventHandler)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: Constants.defaultPaddings))
        return box
    }
    
    private enum Constants {
        static let defaultPaddings = UIEdgeInsets(top: 24, left: 8, bottom: 8, right: 8)
    }
}

extension DSTableBlockPlaneOrgBuilder: DSViewMockableBuilderProtocol {
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
                    smallEmojiPanelMlc: DSSmallEmojiPanelMlcl(label: "label", icon: .mock),
                    btnLinkAtm: .mock
                )
            ],
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
