
import UIKit
import DiiaCommonTypes

public struct DSStatusMessageBuilder: DSViewBuilderProtocol {
    public let modelKey = "statusMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: ParameterizedStatusMessage = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = ParameterizedStatusInfoView()
        view.configure(message: data, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let boxView = BoxView(subview: view).withConstraints(insets: insets)
        return boxView
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
}

extension DSStatusMessageBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = ParameterizedStatusMessage(
            title: "title",
            icon: "👍",
            text: "text",
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
