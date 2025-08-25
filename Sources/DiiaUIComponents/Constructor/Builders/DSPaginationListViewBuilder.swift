
import UIKit
import DiiaCommonTypes

public struct DSPaginationListViewBuilder: DSViewBuilderProtocol {
    
    public let modelKey = "paginationListOrg"
    
    public init() {}
    
    public func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric? = nil,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPaginationListModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSConstructorPaginationView()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        let viewModel = DSConstructorPaginationViewModel(model: data)
        view.set(eventHandler: eventHandler)
        view.configure(viewModel: viewModel)
        return view
    }
}

extension DSPaginationListViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSPaginationListModel(componentId: "componentId", limit: 50, showDivider: false)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
