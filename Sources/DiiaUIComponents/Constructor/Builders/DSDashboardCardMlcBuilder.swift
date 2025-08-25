
import UIKit
import DiiaCommonTypes

public struct DSDashboardCardMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "dashboardCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSDashboardCardMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        let viewModel = DSDashboardCardMlcViewModel(dashboardCardMlc: model,
                                                    eventHandler: eventHandler)
        let view = DSDashboardCardMlcView()
        view.configure(with: viewModel)
        return BoxView(subview: view).withConstraints(insets: .allSides(Constants.offset))
    }
}

extension DSDashboardCardMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSDashboardCardMlc(
            componentId: "componentId",
            type: .description,
            icon: "home",
            label: "Dashboard Card",
            amountLarge: "1,234",
            amountSmall: "UAH",
            description: "Card description text",
            iconCenter: "info",
            descriptionCenter: "Center description",
            action: DSActionParameter.mock,
            btnSemiLightAtm: DSButtonModel.mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private extension DSDashboardCardMlcBuilder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
