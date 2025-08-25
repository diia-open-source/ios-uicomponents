
import UIKit
import DiiaCommonTypes

struct PaymentInfoV2Builder: DSViewBuilderProtocol {
    public let modelKey = "paymentInfoOrgV2"
    
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: PaymentInfoOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = PaymentsInfoV2View()
        view.configure(for: data, eventHandler: eventHandler)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension PaymentInfoV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let itemBuilder = DSTableItemHorizontalLargeMlcBuilder()
        let model = PaymentInfoOrg(
            componentId: "componentId",
            title: "title",
            subtitle: "subtitle",
            items: [],
            tableItemHorizontalLargeMlc: itemBuilder.makeMockModel().parseValue(forKey: itemBuilder.modelKey)
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
