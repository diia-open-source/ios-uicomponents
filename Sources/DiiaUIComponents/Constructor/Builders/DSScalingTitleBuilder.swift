
import UIKit
import DiiaCommonTypes

/// design_system_code: scalingTitleMlc
public struct DSScalingTitleBuilder: DSViewBuilderProtocol {
    public static let modelKey = "scalingTitleMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSScalingTitleMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = makeView(from: data,
                            eventHandler: eventHandler)
        return view
    }
    
    public func makeView(from object: DSScalingTitleMlc,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSScalingTitleView()
        view.configure(data: object)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.padding)
        return paddingBox
    }
}

private extension DSScalingTitleBuilder {
    enum Constants {
        static let padding = UIEdgeInsets(top: 32, left: 24, bottom: 16, right: 24)
    }
}
