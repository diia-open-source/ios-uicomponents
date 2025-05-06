
import UIKit
import DiiaCommonTypes

public struct DSPaginationListWhiteViewBuilder: DSViewBuilderProtocol {
    
    public static let modelKey = "paginationListWhiteOrg"
    
    public init() {}
    
    public func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric? = nil,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPaginationListModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSConstructorWhitePaginationView()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        let viewModel = DSConstructorPaginationViewModel(model: data)
        view.set(eventHandler: eventHandler)
        view.configure(with: viewModel)
        let boxView = BoxView(subview: view)
            .withConstraints(insets: Constants.tablePadding)
        return boxView
    }
}

extension DSPaginationListWhiteViewBuilder {
    enum Constants {
        static let tablePadding = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
    }
}
