
import UIKit
import DiiaCommonTypes

public struct DSStatusMessageBuilder: DSViewBuilderProtocol {
    public static let modelKey = "statusMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: ParameterizedStatusMessage = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = ParameterizedStatusInfoView()
        view.configure(message: data, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        let insets = paddingType.defaultPadding()
        let boxView = BoxView(subview: view).withConstraints(insets: insets)
        return boxView
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
}
