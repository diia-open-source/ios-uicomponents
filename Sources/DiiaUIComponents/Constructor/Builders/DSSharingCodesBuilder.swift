
import UIKit
import DiiaCommonTypes

struct DSSharingCodesBuilder: DSViewBuilderProtocol{
    
    public let modelKey = "sharingCodesOrg"
    
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        
        guard let data: DSSharingCodesOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSSharingCodesOrgView()

        let stubMsgModel = data.stubMessageMlc
        
        let stubViewModel = StubMessageViewModel(model: stubMsgModel,
                                                 repeatAction: {
            if let parameters = stubMsgModel.btnStrokeAdditionalAtm?.action {
                eventHandler(.action(parameters))
            }
        })
        let plainButtonViewModels = data.btnLoadIconPlainGroupMlc?.items.map({button in
            let btnPlainIconAtm = button.btnLoadPlainIconAtm
            return IconedLoadingStateViewModel(
                name: btnPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: btnPlainIconAtm.icon) ?? UIImage(),
                clickHandler: {
                    if let parameters = btnPlainIconAtm.action {
                        eventHandler(.action(parameters))
                    }
                },
                componentId: btnPlainIconAtm.componentId)
        })
        let viewModel = DSSharingCodesOrgViewModel(sharingCodes: data,
                                                   stubViewModel: stubViewModel,
                                                   itemsVMs: plainButtonViewModels)
        view.configure(for: viewModel)
        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: Constants.padding))
        return box
    }
}

private extension DSSharingCodesBuilder {
    enum Constants {
        static let padding = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}

extension DSSharingCodesBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSharingCodesOrg(
            componentId: "componentId",
            expireLabel: DSExpireLabelBox(expireLabelFirst: "expireLabelFirst", expireLabelLast: "expireLabelLast", timer: 320),
            qrCodeMlc: QRCodeMlc(qrLink: "qrLink", componentId: "componentId"),
            btnLoadIconPlainGroupMlc: DSBtnLoadPlainGroupMlc(items: [
                DSBtnLoadPlainIconAtm(btnLoadPlainIconAtm: .mock)
            ], componentId: "componentId"),
            stubMessageMlc: DSStubMessageMlc.mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
