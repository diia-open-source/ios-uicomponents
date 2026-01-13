
// ds_code btnWhiteLargeIconAtm
import DiiaCommonTypes
import UIKit

public struct DSBtnWhiteLargeIconAtmBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnWhiteLargeIconAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSBtnPlainIconModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let button = ActionButton()
        button.type = .full
        button.setupUI(font: FontBook.usualFont, cornerRadius: Constants.cornerRadius)
        button.withHeight(Constants.buttonHeight)
        button.titleEdgeInsets = Constants.buttonTitlePaddings
        button.action = Action(
            title: model.label,
            image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.icon) ?? UIImage()) {
                guard let action = model.action else { return }
                eventHandler(.action(action))
            }
        let paddingBox = BoxView(subview: button).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSBtnWhiteLargeIconAtmBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSBtnPlainIconModel(
            id: "mock_button_id",
            state: .enabled,
            label: "Mock Button Label",
            icon: "home",
            action: DSActionParameter(
                type: "button",
                subtype: "white_large_icon",
                resource: "mock_resource",
                subresource: "mock_subresource"
            ),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

extension DSBtnWhiteLargeIconAtmBuilder {
    private enum Constants {
        static let buttonHeight: CGFloat = 56
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let buttonTitlePaddings: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
    }
}
