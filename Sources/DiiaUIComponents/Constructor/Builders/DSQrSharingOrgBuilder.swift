
import UIKit
import DiiaCommonTypes

public struct DSQRSharingOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "qrSharingOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSQRSharingOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSQRSharingView()
        
        let stubViewModel = StubMessageViewModel(icon: data.stubMessageMlc?.icon ?? "",
                                                 title: data.stubMessageMlc?.title,
                                                 descriptionText: data.stubMessageMlc?.description,
                                                 componentId: data.stubMessageMlc?.componentId,
                                                 repeatAction: {
            if let action = data.stubMessageMlc?.btnStrokeAdditionalAtm?.action {
                eventHandler(.action(action))
            }
        })
        
        let plainButtonViewModels = data.btnIconPlainGroupMlc?.items.map({button in
            let btnPlainIconAtm = button.btnPlainIconAtm
            return IconedLoadingStateViewModel(
                name: btnPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: btnPlainIconAtm.icon) ?? UIImage(),
                clickHandler: {
                    if let action = btnPlainIconAtm.action {
                        eventHandler(.action(action))
                    }
                },
                componentId: btnPlainIconAtm.componentId)
        })
        let viewModel = DSQRSharingViewModel(qrSharingOrg: data,
                                             stubViewModel: data.stubMessageMlc == nil ? nil : stubViewModel,
                                             plainButtonViewModels: plainButtonViewModels)
        view.configure(viewModel: viewModel)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: .allSides(Constants.offset)))
        return box
    }
}

private extension DSQRSharingOrgBuilder {
    enum Constants {
        static let offset: CGFloat = 20
    }
}

// MARK: - Mock
extension DSQRSharingOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSQRSharingOrg(
            componentId: "componentId",
            expireLabel: QRExpireObjectLabel(
                text: "text",
                parameters: [
                    QRExpireObjectParameters(
                        type: .link,
                        data: QRSharingParameterData(
                            name: "name",
                            alt: "alt",
                            resource: "resource",
                            timerTime: 180
                        )
                    )
                ]
            ),
            qrLink: "https://mockUrl/qrLink",
            btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc(items: [DSBtnPlainIconAtm(btnPlainIconAtm: .mock)], componentId: "componentId"),
            stubMessageMlc: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
