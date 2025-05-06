
import UIKit
import DiiaCommonTypes

/// design_system_code: tableMainHeadingMlc
public struct DSTableMainHeadingBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableMainHeadingMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableHeadingItemModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let headingView = DSTableMainHeadingView()
        headingView.configure(with: DSTableMainHeadingViewModel(
            componentId: data.componentId,
            label: data.label,
            description: data.description
        ))
        
        return headingView
    }
}
