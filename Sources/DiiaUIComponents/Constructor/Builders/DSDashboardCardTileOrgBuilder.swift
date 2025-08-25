
import UIKit
import DiiaCommonTypes

public struct DSDashboardCardTileOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "dashboardCardTileOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSDashboardCardTileOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let viewModel = DSDashboardCardTileViewModel(dashboardItems: model.items,
                                                     eventHandler: eventHandler)
        let view = DSDashboardCardTileOrgView()
        view.accessibilityIdentifier = model.componentId
        view.configure(with: viewModel)
        return BoxView(subview: view).withConstraints(insets: Constants.offset)
    }
}

extension DSDashboardCardTileOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let cardItem1 = DSDashboardCardItem(dashboardCardMlc: DSDashboardCardMlc(
            componentId: "componentId",
            type: .description,
            icon: "home",
            label: "Card 1",
            amountLarge: "2,345",
            amountSmall: "UAH",
            description: "First dashboard card",
            iconCenter: "info",
            descriptionCenter: "Center text",
            action: DSActionParameter.mock,
            btnSemiLightAtm: DSButtonModel.mock
        ))
        let cardItem2 = DSDashboardCardItem(dashboardCardMlc: DSDashboardCardMlc(
            componentId: "componentId",
            type: .button,
            icon: "homedoc",
            label: "Card 2",
            amountLarge: nil,
            amountSmall: nil,
            description: "Second dashboard card",
            iconCenter: nil,
            descriptionCenter: nil,
            action: nil,
            btnSemiLightAtm: DSButtonModel.mock
        ))
        
        let model = DSDashboardCardTileOrg(
            componentId: "componentId",
            items: [cardItem1, cardItem2]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private extension DSDashboardCardTileOrgBuilder {
    enum Constants {
        static let offset = UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 24)
    }
}
