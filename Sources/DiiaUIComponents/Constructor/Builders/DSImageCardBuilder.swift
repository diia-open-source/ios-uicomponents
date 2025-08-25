
import UIKit
import DiiaCommonTypes

public struct DSImageCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "imageCardMlc"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSImageCardModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSImageCardView()
        view.configure(with: data) {
            eventHandler(.action(data.action))
        }

        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSImageCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSImageCardModel(
            componentId: "componentId",
            image: "https://mockurl.com/image.png",
            label: "Mock Image Card Label",
            imageAltText: "Mock image alternative text",
            iconRight: "home",
            action: .mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
}
