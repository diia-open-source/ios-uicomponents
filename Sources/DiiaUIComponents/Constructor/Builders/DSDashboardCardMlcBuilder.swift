
import UIKit
import DiiaCommonTypes

public struct DSDashboardCardMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "dashboardCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSDashboardCardMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        let viewModel = DSDashboardCardMlcViewModel(dashboardCardMlc: model,
                                                    eventHandler: eventHandler)
        let view = DSDashboardCardMlcView()
        view.configure(with: viewModel)
        return BoxView(subview: view).withConstraints(insets: .allSides(Constants.offset))
    }
}

private extension DSDashboardCardMlcBuilder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
