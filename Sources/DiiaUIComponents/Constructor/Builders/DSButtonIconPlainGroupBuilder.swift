
import UIKit
import DiiaCommonTypes

struct DSButtonIconPlainGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnIconPlainGroupMlc"
    
    public func makeView(from object: AnyCodable,
                  withPadding paddingType: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBtnIconPlainGroupMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = BorderedActionsView()
        view.accessibilityIdentifier = data.componentId
        view.setupUI(stackSpacing: Constants.spacing)
        let iconVMs = data.items.map({ button in
            let btnLoadPlainIconAtm = button.btnPlainIconAtm
            let viewModel = IconedLoadingStateViewModel(
                name: btnLoadPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: btnLoadPlainIconAtm.icon) ?? UIImage(),
                componentId: btnLoadPlainIconAtm.componentId)
            if let action = btnLoadPlainIconAtm.action {
                viewModel.clickHandler = {
                    eventHandler(.buttonLoadIconAction(
                        parameters: action,
                        viewModel: viewModel))
                }
            }
            return viewModel
        })
        view.configureView(with: iconVMs)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSButtonIconPlainGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBtnIconPlainGroupMlc(
            items: [
                DSBtnPlainIconAtm(
                    btnPlainIconAtm: DSBtnPlainIconModel(
                        id: "mock_button_1",
                        state: .enabled,
                        label: "Home",
                        icon: "home",
                        action: DSActionParameter(
                            type: "button",
                            subtype: "plain_group",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        ),
                        componentId: "componentId"
                    )
                ),
                DSBtnPlainIconAtm(
                    btnPlainIconAtm: DSBtnPlainIconModel(
                        id: "mock_button_2",
                        state: .enabled,
                        label: "Info",
                        icon: "info",
                        action: DSActionParameter(
                            type: "button",
                            subtype: "plain_group",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        ),
                        componentId: "componentId"
                    )
                )
            ],
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private enum Constants {
    static let spacing: CGFloat = 16
}
