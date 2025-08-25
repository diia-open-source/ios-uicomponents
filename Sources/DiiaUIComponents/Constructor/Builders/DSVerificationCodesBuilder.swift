
import DiiaCommonTypes
import UIKit

public struct DSVerificationCodesBuilder: DSViewBuilderProtocol {
    public let modelKey = "verificationCodesOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSVerificationCodesModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let verificationCodesView = DSVerificationCodesView()
        let verificationContainer = BoxView(subview: verificationCodesView).withConstraints(insets: Constants.codePadding)
        let viewModel = DSVerificationCodesViewModel(componentId: data.componentId,
                                                     model: data.UA,
                                                     repeatAction: {})
        verificationContainer.heightAnchor.constraint(
            equalTo: verificationContainer.widthAnchor,
            multiplier: Constants.codeViewHeightProportion
        ).isActive = true
        
        verificationCodesView.configure(with: viewModel)
        
        eventHandler(.onComponentConfigured(with: .verificationOrg(viewModel: viewModel)))
        
        return verificationContainer
    }
}

private enum Constants {
    static let codePadding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    static let codeViewHeightProportion: CGFloat = 1.4
}

extension DSVerificationCodesBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let mockCodesData = DSVerificationCodesData(
            expireLabel: DSExpireLabelBox(
                expireLabelFirst: "expireLabelFirst",
                expireLabelLast: "expireLabelLast",
                timer: 300
            ),
            qrCodeMlc: QRCodeMlc(qrLink: "qrLink", componentId: "componentId"),
            barCodeMlc: BarCodeMlc(barCode: "barCode", componentId: "componentId"),
            toggleButtonGroupOrg: DSToggleButtonGroupModel(
                componentId: "componentId",
                items: [DSToggleButtonModel(
                    btnToggleMlc: DSBtnToggleModel(
                        code: "code",
                        label: "label",
                        selected: DSBtnToggleSelection(icon: "icon", action: .mock),
                        notSelected: DSBtnToggleSelection(icon: "icon", action: .mock)
                    )
                )],
                preselected: "preselectedcode"
            ),
            stubMessageMlc: DSStubMessageMlc(
                icon: "icon",
                title: "title",
                description: "description",
                componentId: "componentId",
                parameters: [
                    TextParameter(
                        type: .link,
                        data: TextParameterData(name: "name", alt: "alt", resource: "resource")
                    )
                ],
                btnStrokeAdditionalAtm: .mock
            )
        )
        let model = DSVerificationCodesModel(
            componentId: "componentId",
            UA: mockCodesData,
            EN: mockCodesData
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
