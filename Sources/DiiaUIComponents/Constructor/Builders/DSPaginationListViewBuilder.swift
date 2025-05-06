
import UIKit
import DiiaCommonTypes

public struct DSPaginationListViewBuilder: DSViewBuilderProtocol {
    
    public static let modelKey = "paginationListOrg"
    
    public init() {}
    
    public func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric? = nil,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPaginationListModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSConstructorReusablePaginationView()
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        let viewModel = DSConstructorPaginationViewModel(model: data)
        view.set(eventHandler: eventHandler)
        view.configure(viewModel: viewModel)
        return view
    }
}
