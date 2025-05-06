
import UIKit
import DiiaCommonTypes

public struct DSButtonIconGroupBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnLoadIconPlainGroupMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSBtnLoadPlainGroupMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = BorderedActionsView()
        view.accessibilityIdentifier = data.componentId
        view.setupUI(stackSpacing: Constants.spacing)
        let iconVMs = data.items.map({ button in
            let btnLoadPlainIconAtm = button.btnLoadPlainIconAtm
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
        
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

private enum Constants {
    static let spacing: CGFloat = 16
}
