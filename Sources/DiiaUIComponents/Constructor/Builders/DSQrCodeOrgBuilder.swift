
import UIKit
import DiiaCommonTypes

struct DSQrCodeOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "qrCodeOrg"

    public func makeView(from object: AnyCodable,
                  withPadding paddingType: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSQrCodeOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSQrCodeOrgView()
        view.accessibilityIdentifier = model.componentId

        let viewModel = DSQrCodeOrgViewModel(model: model)
        view.configure(viewModel: viewModel, eventHandler: eventHandler)

        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSQrCodeOrgBuilder: DSViewMockableBuilderProtocol {
    func makeMockModel() -> AnyCodable {
        let model = DSQrCodeOrgModel(
            componentId: "componentId",
            text: "text",
            qrCodeMlc: QRCodeMlc(qrLink: "https://mockUrl/qrLink", componentId: "componentId"),
            expireLabel: DSExpireLabelBox(expireLabelFirst: "expireLabelFirst", expireLabelLast: "expireLabelLast", timer: 180),
            stateAfterExpiration: DSQrCodeOrgModelExpirationModel(
                paginationMessageMlc: DSPaginationMessageMlcModel(
                    componentId: "componentId",
                    title: "title",
                    description: "description",
                    btnStrokeAdditionalAtm: .mock
                )
            )
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
