
import UIKit
import DiiaCommonTypes

struct DSPaymentInfoBuilder: DSViewBuilderProtocol {
    public let modelKey = "paymentInfoOrg"
    
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableBlockItemModel = object.parseValue(forKey: modelKey) else { return nil }
        
        let view = PaymentsInfoView()
        view.setupPaymentInfo(paymentInfoOrg: data)
        view.setupUI(backgroundColor: .white)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSPaymentInfoBuilder: DSViewMockableBuilderProtocol {
    func makeMockModel() -> AnyCodable {
        let model = DSTableBlockItemModel(
            tableMainHeadingMlc: .mock,
            tableSecondaryHeadingMlc: .mock,
            items: [
                DSTableItem(
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
