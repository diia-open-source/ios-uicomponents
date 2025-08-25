
import UIKit
import DiiaCommonTypes

public struct DSPaginationListWhiteViewBuilder: DSViewBuilderProtocol {
    
    public let modelKey = "paginationListWhiteOrg"
    
    public init() {}
    
    public func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric? = nil,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPaginationListModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSConstructorWhitePaginationView()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        let viewModel = DSConstructorPaginationViewModel(model: data)
        view.set(eventHandler: eventHandler)
        view.configure(with: viewModel)
        let boxView = BoxView(subview: view)
            .withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return boxView
    }
}

extension DSPaginationListWhiteViewBuilder {
    enum Constants {
        static let tablePadding = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
    }
}

extension DSPaginationListWhiteViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSPaginationListModel(componentId: "componentId", limit: 50, showDivider: false)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
