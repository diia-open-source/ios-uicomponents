
import UIKit
import DiiaCommonTypes

public struct DSWhiteCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "whiteCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSWhiteCardModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSWhiteCardView()
        let viewModel = DSWhiteCardViewModel(
            image: data.image,
            title: data.title,
            label: data.label,
            accessibilityDescription: data.accessibilityDescription,
            smallIcon: data.smallIconAtm,
            icon: data.iconAtm,
            largeIcon: data.largeIconAtm,
            doubleIcon: data.doubleIconAtm) {
                eventHandler(.action(data.action))
            }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
