
import UIKit
import DiiaCommonTypes

public struct BankingCardBuilder: DSViewBuilderProtocol {
    public static let modelKey = "bankingCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: BankingCardMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = BankingCardView()
        view.accessibilityIdentifier = data.componentId
        
        let viewModel = BankingCardViewModel(model: data) {
            if let action = data.action {
                eventHandler(.action(action))
            }
        }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

