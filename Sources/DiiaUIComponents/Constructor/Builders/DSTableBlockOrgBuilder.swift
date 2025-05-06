
import UIKit
import DiiaCommonTypes

public struct DSTableBlockOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableBlockOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockItemModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSTableBlocksView()
        view.configure(model: [model], eventHandler: eventHandler)
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let boxView = BoxView(subview: view).withConstraints(insets: insets)
        return boxView
    }
    
    private enum Constants {
        static let defaultPaddings = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        static let smallPaddings = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}
