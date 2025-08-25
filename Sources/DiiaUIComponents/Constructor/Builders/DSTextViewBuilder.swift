
import UIKit
import DiiaCommonTypes

/// design_system_code: textLabelContainerMlc
public struct DSTextViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "textLabelContainerMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTextContainerData = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTextContainerView()
        view.configure(data: data)
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = Constants.cornerRadius
        container.addSubview(view)
        view.fillSuperview(padding: Constants.contentInset)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: container).withConstraints(insets: insets)
        return paddingBox
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
    static let contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}

extension DSTextViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTextContainerData(
            componentId: "componentId",
            text: "text",
            label: "label",
            parameters: [
                TextParameter(
                    type: .link,
                    data: TextParameterData(name: "name", alt: "alt", resource: "resource")
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
