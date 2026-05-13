
import UIKit
import DiiaCommonTypes

struct DSPaymentInfoV2Builder: DSViewBuilderProtocol {
    public let modelKey = "paymentInfoOrgV2"
    
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPaymentInfoOrgV2Model = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSPaymentsInfoV2View()
        view.configure(for: data, eventHandler: eventHandler)
        if let viewFabric {
            view.setFabric(viewFabric)
        }

        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSPaymentInfoV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let itemBuilder = DSTableItemHorizontalLargeMlcBuilder()
        let model = DSPaymentInfoOrgV2Model(
            componentId: "componentId",
            title: "title",
            titleWithChip: DSPaymentInfoOrgV2Model.TitleWithChipModel(
                text: "titleWithChip text titleWithChip text titleWithChip text",
                description: "titleWithChip description, titleWithChip description, titleWithChip description",
                chipStatusAtm: .mock),
            subtitle: "subtitle",
            items: [],
            tableItemHorizontalLargeMlc: itemBuilder.makeMockModel().parseValue(forKey: itemBuilder.modelKey),
            btnPrimaryAdditionalAtm: nil,
            btnIconPlainStrokeMlc: nil,
            description: "description"
        )

        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
