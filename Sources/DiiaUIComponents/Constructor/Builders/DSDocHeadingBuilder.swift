import UIKit
import DiiaCommonTypes

public struct DSDocHeadingBuilder: DSViewBuilderProtocol {
    public static let modelKey = "docHeadingOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let docModel: DSDocumentHeading = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSDocumentHeadingView()
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.padding)
        view.configure(model: docModel)
        return paddingBox
    }
}

extension DSDocHeadingBuilder {
    private enum Constants {
        static let padding = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
}
