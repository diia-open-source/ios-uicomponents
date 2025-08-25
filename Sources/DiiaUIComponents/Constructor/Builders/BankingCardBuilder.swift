
import UIKit
import DiiaCommonTypes

public struct BankingCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "bankingCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: BankingCardMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = BankingCardView()
        view.accessibilityIdentifier = data.componentId
        
        let viewModel = BankingCardViewModel(model: data) {
            if let action = data.action {
                eventHandler(.action(action))
            }
        }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension BankingCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = BankingCardMlc(
            componentId: "componentId",
            id: "id",
            title: "title",
            image: "image",
            gradient: "gradient",
            paymentSystemLogo: "paymentSystemLogo",
            cardNumMask: "cardNumMask",
            expirationDate: "expirationDate",
            logos: [
                .init(mediumIconAtm: DSIconModel(
                        code: "code",
                        accessibilityDescription: "accessibilityDescription",
                        componentId: "componentId",
                        action: .init(type: "iconAction"),
                        isEnable: true
                    )
                )],
            description: "description",
            action: .init(type: "BankingCardMlcAction")
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
