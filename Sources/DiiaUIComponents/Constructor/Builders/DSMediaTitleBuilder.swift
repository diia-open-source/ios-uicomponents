
import UIKit
import DiiaCommonTypes

public struct DSMediaTitleBuilder: DSViewBuilderProtocol {
    public static let modelKey = "mediaTitleOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSMediaTitleModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSMediaTitleView()
        view.configure(
            with: DSMediaTitleViewModel(model: data) {
                if let action = data.btnPlainIconAtm.action {
                    eventHandler(.action(action))
                }
            }
        )
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

private enum Constants {
    static let defaultPaddings = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    static let smallPaddings = UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 24)
}
