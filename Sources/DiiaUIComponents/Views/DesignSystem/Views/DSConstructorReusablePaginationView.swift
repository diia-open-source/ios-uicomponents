
import UIKit
import DiiaCommonTypes

public protocol FixSizedViewProtocol {
    func setHeight(constant: CGFloat)
    func setHeightEqual(to view: UIView)
}

public extension FixSizedViewProtocol where Self: UIView {
    func setHeight(constant: CGFloat) {
        self.withHeight(constant)
    }
    
    func setHeightEqual(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
    }
}

public protocol FullSizedViewProtocol: FixSizedViewProtocol {}

public class DSConstructorReusablePaginationView: BaseCodeView, DSConstructorPaginationViewDelegate, FullSizedViewProtocol, ScrollDependentComponentProtocol {
    private let tableView: UITableView = .init()
    private lazy var loadingView = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(loadingImage: R.image.blackGradientSpinner.image)
        let view = AnimationView(loadingContainer)
        view.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: Constants.loadingHeight)
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
        let size = CGSize(width: tableView.frame.width, height: Constants.errorHeight)
        view.frame = .init(origin: .zero, size: size)
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
        let views = items.compactMap { viewFabric.makeView(from: $0, withPadding: .default, eventHandler: eventHandler) }
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
            tableView.tableFooterView = UIView(frame: .zero)
        case .loading:
            tableView.tableFooterView = loadingView
        case .error:
            tableView.tableFooterView = errorView
        }
    }
    
    public func setStubMessage(_ items: [AnyCodable]) {
        backgroundColor = .clear
        addItems(items)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewFrame = scrollView.convert(self.bounds, from: self)
        let scrollBottomPosition = scrollView.contentOffset.y + scrollView.bounds.height
        self.tableView.isScrollEnabled = viewFrame.maxY <= scrollBottomPosition
    }
}

extension DSConstructorReusablePaginationView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViews.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstructorPaginationContainerCell.reuseID,
                                                       for: indexPath) as? ConstructorPaginationContainerCell
        else {
            return ConstructorPaginationContainerCell()
        }
        
        if indexPath.row == itemViews.count - 1,
            let dict = viewModel?.items.first?.dictionary,
            dict.keys.first(where: { $0 == DSEmptyStateViewBuilder.modelKey}) == nil {
            fetchNextBatchIfNeeded()
        }
        
        let view = itemViews[indexPath.row]
        let isLastCell = indexPath.row == itemViews.count - 1
        let showSeparator = viewModel?.showSeparator == true && !isLastCell

        cell.setSubview(view)
        cell.showSeparator(showSeparator)
 
        return cell
    }
}

private extension DSConstructorReusablePaginationView {
    enum Constants { 
        static let loadingHeight: CGFloat = 56
        static let retryHeight:  CGFloat = 36
        static let retrySpacing:  CGFloat = 8
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 62)
        static let retryPadding = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
        static let errorHeight: CGFloat = 104
    }
}
