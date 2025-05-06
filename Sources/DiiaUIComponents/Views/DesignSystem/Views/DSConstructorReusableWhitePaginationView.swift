
import UIKit
import DiiaCommonTypes

public class DSConstructorReusableWhitePaginationView: BaseCodeView, DSConstructorPaginationViewDelegate, FullSizedViewProtocol, ScrollDependentComponentProtocol {
    
    private let tableView = UITableView()
   
    private lazy var loadingView = {
        let loadingView = LoadingContainerView()
        loadingView.configure(loadingImage: UIImage(named: "spinner"))
        let view = AnimationView(loadingView)
        view.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: Constants.loadingHeight)
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private lazy var errorView = {
        let view = UIView()
        let errorLabel = UILabel().withParameters(font: FontBook.usualFont)
        errorLabel.text = R.Strings.pagination_error_text.localized()
        errorLabel.textAlignment = .center
        let retryButton = ActionLoadingStateButton()
        retryButton.titleLabel?.font = FontBook.usualFont
        retryButton.setStyle(style: .light)
        retryButton.withHeight(Constants.retryHeight)
        retryButton.onClick = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.eventHandler(.paginationScroll(event: .didTapRetry, viewModel: viewModel))
        }
        retryButton.contentEdgeInsets = Constants.buttonEdgeInsets
        retryButton.setLoadingState(.enabled, withTitle: R.Strings.general_update.localized())
        view.stack(
            [
                errorLabel,
                retryButton
            ],
            spacing: Constants.retrySpacing,
            alignment: .center,
            padding: Constants.retryPadding
        )
        view.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: Constants.errorHeight)
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    private var itemViews: [UIView] = []
    private var viewFabric = DSViewFabric.instance
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    
    private var viewModel: DSConstructorPaginationViewModel?
    
    public override func setupSubviews() {
        addSubview(tableView)
        tableView.fillSuperview()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: ConstructorPaginationContainerCell.self)
    }
    
    private func fetchNextBatchIfNeeded() {
        guard let viewModel = viewModel,
              viewModel.state == .ready,
              viewModel.items.count < viewModel.total
        else { return }
        eventHandler(.paginationScroll(event: .didScrollToEnd, viewModel: viewModel))
    }
    
    func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    public func configure(viewModel: DSConstructorPaginationViewModel) {
        self.viewModel = viewModel
        viewModel.paginationViewDelegate = self
        eventHandler(.paginationScroll(event: .didScrollToEnd, viewModel: viewModel))
        clearItems()
        addItems(viewModel.items)
    }
    
    public func addItems(_ items: [AnyCodable]) {
        let views = items.compactMap {
            return viewFabric.makeView(from: $0, withPadding: .default, eventHandler: eventHandler)
        }
        
        itemViews.append(contentsOf: views)
        tableView.reloadData()
    }
    
    public func clearItems() {
        itemViews = []
        tableView.reloadData()
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    public func setState(state: PaginationViewState) {
        switch state {
        case .ready, .silentLoading:
            tableView.tableFooterView = nil
        case .loading:
            tableView.tableFooterView = loadingView
        case .error:
            tableView.tableFooterView = errorView
        }
        updateLastCell()
    }
    
    private func updateLastCell() {
        guard !itemViews.isEmpty else { return }
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: itemViews.count - 1, section: .zero)], with: .automatic)
        tableView.endUpdates()
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewFrame = scrollView.convert(self.bounds, from: self)
        let scrollBottomPosition = scrollView.contentOffset.y + scrollView.bounds.height + 32
        self.tableView.isScrollEnabled = viewFrame.maxY <= scrollBottomPosition
    }
}

extension DSConstructorReusableWhitePaginationView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViews.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstructorPaginationContainerCell.reuseID,
                                                       for: indexPath) as? ConstructorPaginationContainerCell
        else {
            return ConstructorPaginationContainerCell()
        }
        
        if indexPath.row == itemViews.count - 1 {
            fetchNextBatchIfNeeded()
        }
        let view = itemViews[indexPath.row]
        let boxView = BoxView(subview: view)
        view.backgroundColor = .white
        view.layer.cornerRadius = .zero
        
        if indexPath.row == .zero {
            view.layer.cornerRadius = Constants.cornerRadius
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else if (indexPath.row == itemViews.count - 1) && tableView.tableFooterView == nil {
            view.layer.cornerRadius = Constants.cornerRadius
            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        cell.setSubview(boxView)
        
        return cell
    }
}

private extension DSConstructorReusableWhitePaginationView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let loadingHeight: CGFloat = 56
        static let retryHeight:  CGFloat = 36
        static let retrySpacing:  CGFloat = 16
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        static let retryPadding = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 24)
        static let errorHeight: CGFloat = 136
    }
}
