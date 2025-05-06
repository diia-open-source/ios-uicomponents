
import UIKit
import DiiaCommonTypes

public struct DSTableBlockPlaneOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableBlockPlaneOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockItemModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSTableBlockPlaneOrgView()
        view.configure(for: model, eventHandler: eventHandler)
        let boxView = BoxView(subview: view).withConstraints(insets: Constants.defaultPaddings)
        return boxView
    }
    
    private enum Constants {
        static let defaultPaddings = UIEdgeInsets(top: 24, left: 8, bottom: 8, right: 8)
    }
}
