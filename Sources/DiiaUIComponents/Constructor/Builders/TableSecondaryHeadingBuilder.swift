
import UIKit
import DiiaCommonTypes

/// design_system_code: tableSecondaryHeadingMlc
public struct TableSecondaryHeadingBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableSecondaryHeadingMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableHeadingItemModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let headingView = TableSecondaryHeadingView()
        let viewModel = TableSecondaryHeadingViewModel(headingModel: data)
        headingView.configure(with: viewModel) {
            if let iconAction = data.icon?.action {
                eventHandler(.action(iconAction))
            }
        }
        
        return BoxView(subview: headingView).withConstraints(insets: paddingType.defaultPadding())
    }
}
