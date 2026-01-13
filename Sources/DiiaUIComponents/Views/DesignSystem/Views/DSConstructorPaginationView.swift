
import UIKit
import DiiaCommonTypes

public struct DSPaginationListModel: Codable {
    public let componentId: String?
    public let limit: Int?
    public let showDivider: Bool?
    
    public init(componentId: String?, limit: Int?, showDivider: Bool?) {
        self.componentId = componentId
        self.limit = limit
        self.showDivider = showDivider
    }
}

public struct DSPaginationItemsModel: Codable {
    public let total: Int?
    public let nextToken: String?
    public let stubMessageMlc: DSStubMessageMlc?
    public let paginationMessageMlc: AnyCodable?
    public let items: [AnyCodable]
    public let template: AlertTemplate?
    
    public init(items: [AnyCodable]?,
                total: Int?,
                nextToken: String?,
                stubMessageMlc: DSStubMessageMlc?,
                paginationMessageMlc: AnyCodable?,
                template: AlertTemplate? = nil) {
        self.items = items ?? []
        self.total = total
        self.nextToken = nextToken
        self.stubMessageMlc = stubMessageMlc
        self.paginationMessageMlc = paginationMessageMlc
        self.template = template
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
        self.nextToken = try container.decodeIfPresent(String.self, forKey: .nextToken)
        self.stubMessageMlc = try container.decodeIfPresent(DSStubMessageMlc.self, forKey: .stubMessageMlc)
        self.paginationMessageMlc = try container.decodeIfPresent(AnyCodable.self, forKey: .paginationMessageMlc)
        self.items = try container.decodeIfPresent([AnyCodable].self, forKey: .items) ?? []
        self.template = try container.decodeIfPresent(AlertTemplate.self, forKey: .template)
    }
}

public enum PaginationViewEvent {
    case didScrollToEnd
    case didTapRetry
}

public enum PaginationViewState {
    case ready
    case silentLoading
    case loading
    case error
    case viewDidResize
    
    public var isLoading: Bool {
        return self == .loading || self == .silentLoading
    }
}

public protocol DSConstructorPaginationViewDelegate: NSObjectProtocol {
    func addItems(_ items: [AnyCodable])
    func clearItems()
    func setState(state: PaginationViewState)
    func setStubMessage(_ items: [AnyCodable])
}

extension DSConstructorPaginationViewDelegate {
    public func setStubMessage(_ items: [AnyCodable]) {}
}

public final class DSConstructorPaginationViewModel {
    public let componentId: String?
    public var items: [AnyCodable] = []
    public var limit: Int = 0
    public var total: Int = .max
    public weak var paginationViewDelegate: DSConstructorPaginationViewDelegate?
    public var state: PaginationViewState = .ready
    public var showSeparator: Bool = false
    
    init(model: DSPaginationListModel) {
        self.componentId = model.componentId
        self.limit = model.limit ?? Constants.pageLimit
        self.showSeparator = model.showDivider ?? false
    }
    
    public func setItems(items: [AnyCodable]) {
        self.items = items
        paginationViewDelegate?.clearItems()
        paginationViewDelegate?.addItems(items)
    }
    
    public func addItems(items: [AnyCodable]) {
        self.items.append(contentsOf: items)
        paginationViewDelegate?.addItems(items)
    }
    
    public func setState(state: PaginationViewState) {
        self.state = state
        paginationViewDelegate?.setState(state: state)
    }
    
    public func setStubMessage(items: [AnyCodable]) {
        self.items = items
        paginationViewDelegate?.setStubMessage(items)
    }
    
    private enum Constants {
        static let pageLimit = 20
    }
}

public final class DSConstructorPaginationView: BaseCodeView, DSConstructorPaginationViewDelegate, ScrollDependentComponentProtocol {
    
    private let mainStack = UIStackView.create()
    private let itemsStack = DSVStackView()
    
    private lazy var loadingView: AnimationView = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(loadingImage: R.image.blackGradientSpinner.image)
        return AnimationView(loadingContainer)
    }()
    
    private lazy var errorView: UIView = {
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
        return view
    }()
    private var viewFabric = DSViewFabric.instance
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    
    private(set) var viewModel: DSConstructorPaginationViewModel?
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        loadingView.withHeight(Constants.loadingHeight)
        mainStack.addArrangedSubviews([itemsStack, loadingView, errorView])
        errorView.isHidden = true
        loadingView.isHidden = true
    }
    
    func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    public func configure(viewModel: DSConstructorPaginationViewModel) {
        self.viewModel = viewModel
        viewModel.paginationViewDelegate = self
        clearItems()
        addItems(viewModel.items)
    }
    
    public func addItems(_ items: [AnyCodable]) {
        itemsStack.isHidden = viewModel?.items.count ?? 0 == 0
        if itemsStack.isHidden { return }
        var views = [UIView]()
        if viewModel?.showSeparator == true, !itemsStack.subviews.isEmpty {
            views.append(createSeparator())
        }
        for (index, item) in items.enumerated() {
            if let view = viewFabric.makeView(from: item, withPadding: .default, eventHandler: eventHandler) {
                views.append(view)
                if viewModel?.showSeparator == true, index < (items.endIndex - 1) {
                    views.append(createSeparator())
                }
            }
        }
        itemsStack.addArrangedSubviews(views)
        itemsStack.setNeedsLayout()
    }
    
    public func clearItems() {
        itemsStack.clearSubviews()
        itemsStack.isHidden = true
    }
    
    public func setStubMessage(_ items: [AnyCodable]) {
        backgroundColor = .clear
        addItems(items)
    }
    
    public func setState(state: PaginationViewState) {
        errorView.isHidden = state != .error
        loadingView.isHidden = state != .loading
        
        switch state {
        case .viewDidResize:
            itemsStack.setNeedsLayout()
            itemsStack.layoutIfNeeded()
        default:
            break
        }
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              viewModel.state == .ready
        else { return }
        let viewFrame = scrollView.convert(self.bounds, from: scrollView)
        let scrollBottomPosition = scrollView.contentOffset.y + scrollView.bounds.height
        if (viewFrame.maxY <= scrollBottomPosition),
           viewModel.items.count < viewModel.total {
            eventHandler(.paginationScroll(event: .didScrollToEnd, viewModel: viewModel))
        }
    }
    
    private func createSeparator() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = Constants.separatorColor
        separatorView.withHeight(1)
        return BoxView(subview: separatorView).withConstraints(insets: Constants.separatorInsets)
    }
}

private extension DSConstructorPaginationView {
    enum Constants {
        static let retrySpacing:  CGFloat = 16
        static let loadingHeight: CGFloat = 56
        static let retryHeight:  CGFloat = 36
        static let separatorInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        static let retryPadding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        static let separatorColor = UIColor("#E2ECF4")
    }
}
