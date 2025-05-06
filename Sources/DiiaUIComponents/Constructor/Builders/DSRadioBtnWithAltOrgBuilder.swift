
import UIKit
import DiiaCommonTypes

public class DSRadioBtnWithAltOrgBuilder: DSViewBuilderProtocol {
    
    public static let modelKey = "radioBtnWithAltOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSRadioBtnWithAltOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSRadioBtnWithAltView()
        view.accessibilityIdentifier = data.componentId
        let viewModel = DSRadioBtnWithAltViewModel(eventHandler: eventHandler,
                                                   items: data.items)
        view.configure(with: viewModel)
        
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSRadioBtnWithAltOrgBuilder {
    enum Constants {
        static let altGroupSpacing: CGFloat = 16
    }
}
