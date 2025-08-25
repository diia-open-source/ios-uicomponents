
import UIKit
import DiiaCommonTypes

public struct DSWhiteCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "whiteCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSWhiteCardModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
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
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSWhiteCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSWhiteCardModel(
            image: "image",
            smallIconAtm: .mock,
            iconAtm: .mock,
            doubleIconAtm: .mock,
            largeIconAtm: .mock,
            title: "title",
            label: "label",
            accessibilityDescription: "accessibilityDescription",
            action: .mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
