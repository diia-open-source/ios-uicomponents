
import UIKit
import DiiaCommonTypes

/// design_system_code: linkQrShareOrg
public struct DSLinkQrShareViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "linkQrShareOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSLinkQrShareModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSLinkQrShareView()
        let viewModel = DSLinkQrShareViewModel(model: model, eventHandler: eventHandler)
        eventHandler(.onComponentConfigured(with: .linkQrShareView(viewModel: viewModel)))
        view.configure(with: viewModel, eventHandler: eventHandler)

        let paddings = paddingType.insets(for: object, modelKey: modelKey, defaultInsets: Constants.defaultInsets)
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddings)
        return paddingBox
    }
}

extension DSLinkQrShareViewBuilder {
    private enum Constants {
        static let defaultInsets = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - Mock
extension DSLinkQrShareViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSLinkQrShareModel(
            componentId: "componentId",
            centerChipBlackTabsOrg: DSCenterChipBlackTabsOrgModel(
                componentId: "componentId",
                items: [
                    DSChipBlackMlcItemModel(
                        chipBlackMlc: DSChipBlackMlcModel(
                            componentId: "componentId",
                            label: "Option 1",
                            code: "code1",
                            active: true,
                            action: .mock
                        )
                    ),
                    DSChipBlackMlcItemModel(
                        chipBlackMlc: DSChipBlackMlcModel(
                            componentId: "componentId",
                            label: "Option 2",
                            code: "code2",
                            active: true,
                            action: .mock
                        )
                    )
                ],
                preselectedCode: "code2"
            ),
            linkSharingOrg: DSLinkSharingOrgModel(
                componentId: "componentId",
                text: "Top textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop text Top textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop text ",
                linkSharingMlc: DSLinkSharingMlcModel(componentId: "componentId", label: "Central label", iconRight: .mock),
                description: "description",
                btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc(
                    items: [DSBtnPlainIconAtm(btnPlainIconAtm: .mock)],
                    componentId: "componentId"
                ),
                paginationMessageMlc: nil
            ),
            qrCodeOrg: DSQrCodeOrgModel(
                componentId: "componentId",
                text: "Top textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop text Top textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop textTop text ",
                qrCodeMlc: QRCodeMlc(qrLink: "https://mock.com", componentId: "componentId"),
                expireLabel: DSExpireLabelBox(expireLabelFirst: "expireLabelFirst", expireLabelLast: "expireLabelLast", timer: 5),
                expireLabelWithoutTimer: nil,
                stateAfterExpiration: DSQrCodeOrgModelExpirationModel(
                    paginationMessageMlc: DSPaginationMessageMlcModel(
                        componentId: "componentId",
                        title: "State after expiration title",
                        description: "State after expiration description",
                        btnStrokeAdditionalAtm: .mock
                    )
                ),
                paginationMessageMlc: nil,
                btnPlainIconAtm: nil
            )
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
