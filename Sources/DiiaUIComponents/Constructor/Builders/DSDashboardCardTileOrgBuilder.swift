
import UIKit
import DiiaCommonTypes

public struct DSDashboardCardTileOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "dashboardCardTileOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSDashboardCardTileOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let viewModel = DSDashboardCardTileViewModel(dashboardItems: model.items,
                                                     eventHandler: eventHandler)
        let view = DSDashboardCardTileOrgView()
        view.accessibilityIdentifier = model.componentId
        view.configure(with: viewModel)
        return BoxView(subview: view).withConstraints(insets: Constants.offset)
    }
}

private extension DSDashboardCardTileOrgBuilder {
    enum Constants {
        static let offset = UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 24)
    }
}
