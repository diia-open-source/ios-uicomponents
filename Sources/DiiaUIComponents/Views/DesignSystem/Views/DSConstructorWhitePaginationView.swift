
import UIKit
import DiiaCommonTypes

public class DSConstructorWhitePaginationView: BaseCodeView, DSConstructorPaginationViewDelegate, ScrollDependentComponentProtocol {
   
    private let paginationView = DSConstructorPaginationView()
    
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        addSubview(paginationView)
        paginationView.fillSuperview()
    }
    
    public func configure(with viewModel: DSConstructorPaginationViewModel) {
        paginationView.configure(viewModel: viewModel)
        viewModel.paginationViewDelegate = self
    }
    
    public func addItems(_ items: [AnyCodable]) {
        paginationView.addItems(items)
    }
    
    public func clearItems() {
        paginationView.clearItems()
    }
    
    public func setState(state: PaginationViewState) {
        backgroundColor = paginationView.viewModel?.items.count == 0 ? .clear : .white
        paginationView.setState(state: state)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        paginationView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    public func setStubMessage(_ items: [AnyCodable]) {
        backgroundColor = .clear
        paginationView.addItems(items)
    }
    
    func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        paginationView.set(eventHandler: eventHandler)
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        paginationView.setFabric(fabric)
    }
}

extension DSConstructorWhitePaginationView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
    }
}
