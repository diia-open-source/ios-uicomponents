
import UIKit
import DiiaCommonTypes

public struct DSButtonIconGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnLoadIconPlainGroupMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBtnLoadPlainGroupMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = BorderedActionsView()
        view.accessibilityIdentifier = data.componentId
        view.setupUI(stackSpacing: Constants.spacing)
        let iconVMs = data.items.map({ button in
            let btnLoadPlainIconAtm = button.btnLoadPlainIconAtm
            let viewModel = IconedLoadingStateViewModel(
                name: btnLoadPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: btnLoadPlainIconAtm.icon) ?? UIImage(),
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

extension DSButtonIconGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBtnLoadPlainGroupMlc(
            items: [
                DSBtnLoadPlainIconAtm(
                    btnLoadPlainIconAtm: DSBtnPlainIconModel(
                        id: "mock_button_1",
                        state: .enabled,
                        label: "Home",
                        icon: "home",
                        action: DSActionParameter(
                            type: "button",
                            subtype: "icon_group",
                            resource: "mock_resource",
                            subresource: "mock_subresource"
                        ),
                        componentId: "componentId"
                    )
                ),
                DSBtnLoadPlainIconAtm(
                    btnLoadPlainIconAtm: DSBtnPlainIconModel(
                        id: "mock_button_2",
                        state: .enabled,
                        label: "Documents",
                        icon: "homedoc",
                        action: DSActionParameter(
                            type: "button",
                            subtype: "icon_group",
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
