
import UIKit
import DiiaCommonTypes

public struct DSTableHeadingWithTextMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableHeadingWithTextMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableHeadingWithTextMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableHeadingWithTextMlcView()
        view.configure(with: data)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSTableHeadingWithTextMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableHeadingWithTextMlc(
            componentId: "testId",
            heading: "Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text Heading text ",
            text: "Test text Test textTest textTest text Test textTest text Test textTest textTest textTest textTest textTest textTest text",
            iconLeft: .mock)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
