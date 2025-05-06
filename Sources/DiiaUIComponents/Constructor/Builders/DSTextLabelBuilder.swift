
import UIKit
import DiiaCommonTypes

/// design_system_code: textLabelMlc
public struct DSTextLabelBuilder: DSViewBuilderProtocol {
    public static let modelKey = "textLabelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTextContainerData = object.parseValue(forKey: Self.modelKey) else { return nil }

        let textView = DSTextContainerView()
        textView.configure(data: data)
        let padding = paddingType.defaultPadding()
        
        let paddingBox = BoxView(subview: textView).withConstraints(insets: padding)
        textView.accessibilityIdentifier = data.componentId
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
    static let numberOfLines = 0
}
