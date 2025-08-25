
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

protocol ConstructorPaginationScreenViewProtocol: BaseView {
    func setLoadingState(_ state: PaginationViewState)
    func setupBackground(_ background: ConstructorBackground)
    func configure(model: DSConstructorModel)
    func setBody(items: [AnyCodable])
    func addBody(items: [AnyCodable])
    func setHeader(headerContext: ContextMenuProviderProtocol)
    func inputFieldsWasUpdated()
    func setUserInteractionEnabled(_ isEnabled: Bool)
    func getInputData() -> [String: AnyCodable]
}

final class ConstructorPaginationScreenViewController: UIViewController, RatingFormHolder {
    
    private var constructorView: ConstructorPaginationScreenView? { view as? ConstructorPaginationScreenView }
    
    // MARK: - Properties
    var presenter: ConstructorPaginationScreenPresenter!

    private let viewFabric: DSViewFabric = .instance
    private var keyboardHandler: KeyboardHandler?

    private var model: DSConstructorModel?
    private var headerContext: ContextMenuProviderProtocol?
    private var conditionViews: [DSConditionComponentProtocol] = []
    private var inputViews: [DSInputComponentProtocol] = []
    
    private var bodyViews: [UIView] = []
    private var bodyConditionViews: [DSConditionComponentProtocol] = []
    private var bodyInputViews: [DSInputComponentProtocol] = []
    
    private var isFirstFetch = true
    private lazy var loadingView = {
        let view = AnimationView(LoadingContainerView())
        view.withHeight(Constants.loadingHeight)
        return view
    }()
    private lazy var errorView = {
        let view = UIView()
        let errorLabel = UILabel().withParameters(font: FontBook.usualFont)
        errorLabel.text = R.Strings.pagination_error_text.localized()
        let retryButton = ActionLoadingStateButton()
        retryButton.titleLabel?.font = FontBook.usualFont
        retryButton.setStyle(style: .light)
        retryButton.withHeight(36)
        retryButton.onClick = { [weak self] in
            self?.presenter.didScrollToEnd()
        }
        retryButton.contentEdgeInsets = Constants.buttonEdgeInsets
        retryButton.setLoadingState(.enabled, withTitle: R.Strings.general_update.localized())
        view.stack(
            [
                errorLabel,
                retryButton
            ],
            alignment: .center,
            padding: .init(top: 20, left: 24, bottom: 0, right: 24)
        )
        return view
    }()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        let view = ConstructorPaginationScreenView(frame: UIScreen.main.bounds)
        view.backgroundColor = .blackSqueeze
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        presenter.configureView()
    }

    private func initialSetup() {
        constructorView?.setupTopGroup(views: [prepareDefaultTopView()])
        setupTableView()
    }
    
    private func setupTableView() {
        constructorView?.bodyTableView.backgroundColor = .clear
        constructorView?.bodyTableView.separatorStyle = .none
        constructorView?.bodyTableView.keyboardDismissMode = .onDrag
        constructorView?.bodyTableView.dataSource = self
        constructorView?.bodyTableView.delegate = self
        constructorView?.bodyTableView.register(cellType: ConstructorPaginationContainerCell.self)
        constructorView?.bodyTableView.tableFooterView = nil
    }
    
    // MARK: - Private
    private func prepareDefaultTopView() -> UIView {
        let topView = TopNavigationView()
        if navigationController?.viewControllers.count ?? 0 > 1 {
            topView.setupOnClose(callback: { [weak self] in
                self?.closeModule(animated: true)
            })
        }
        return topView
    }
    
    private func topView() -> TopNavigationView? {
        if let topView = constructorView?.topGroupStack.arrangedSubviews.first as? TopNavigationView {
            return topView
        }
        return constructorView?.topGroupStack.findFirstSubview(ofType: TopNavigationView.self)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - View logic
extension ConstructorPaginationScreenViewController: ConstructorPaginationScreenViewProtocol {
    public func setLoadingState(_ state: PaginationViewState) {
        if isFirstFetch {
            constructorView?.loadingView.setLoadingState(state.isLoading ? .loading : .ready)
        } else {
            constructorView?.loadingView.setLoadingState(.ready)
            switch state {
            case .ready:
                constructorView?.bodyTableView.setAndLayoutTableFooterView(footer: UIView(frame: .zero))
            case .silentLoading, .loading:
                constructorView?.bodyTableView.setAndLayoutTableFooterView(footer: loadingView)
            case .error:
                constructorView?.bodyTableView.setAndLayoutTableFooterView(footer: errorView)
            default:
                break
            }
        }
    }
    
    public func setupBackground(_ background: ConstructorBackground) {
        switch background {
        case .color(let color):
            constructorView?.backgroundImageView.image = UIImage.from(color: color)
        case .image(let image):
            constructorView?.backgroundImageView.image = image
        }
    }
    
    func configure(model: DSConstructorModel) {
        self.model = model
        
        let eventHandler: (ConstructorItemEvent) -> Void = { [weak self] event in
            self?.presenter.handleEvent(event: event)
        }
        
        let topViews = viewFabric.topGroupViews(for: model, eventHandler: eventHandler)
        let bottomView = viewFabric.bottomGroupViews(for: model, eventHandler: eventHandler)
        
        constructorView?.setupTopGroup(views: topViews)
        constructorView?.setupBottomGroup(views: bottomView)
        
        self.inputViews = view.findTypedSubviews()
        self.conditionViews = view.findTypedSubviews()
        
        if !inputViews.isEmpty,
           let constructorView = constructorView,
           let bottomConstraint = constructorView.bottomGroupBottomConstraint {
            keyboardHandler = .init(type: .constraint(
                constraint: bottomConstraint,
                withoutInset: bottomConstraint.constant,
                keyboardInset: Constants.keyboardSpacing + view.safeAreaInsets.bottom,
                superview: constructorView))
        }
        
        inputFieldsWasUpdated()
        if let headerContext = headerContext {
            setHeader(headerContext: headerContext)
        }
    }
    
    func setBody(items: [AnyCodable]) {
        bodyViews = []
        bodyInputViews = []
        bodyConditionViews = []
        addBody(items: items)
    }
    
    func addBody(items: [AnyCodable]) {
        let eventHandler: (ConstructorItemEvent) -> Void = { [weak self] event in
            self?.presenter.handleEvent(event: event)
        }
        let bodyViews = items.compactMap { viewFabric.makeView(from: $0, withPadding: .default, eventHandler: eventHandler) }
        bodyInputViews.append(contentsOf: bodyViews.flatMap { $0.findTypedSubviews() })
        bodyConditionViews.append(contentsOf: bodyViews.flatMap { $0.findTypedSubviews() })
        self.bodyViews.append(contentsOf: bodyViews)
        constructorView?.bodyTableView.reloadData()
    }
    
    public func setUserInteractionEnabled(_ isEnabled: Bool) {
        constructorView?.bodyTableView.isUserInteractionEnabled = isEnabled
        constructorView?.bottomStack.isUserInteractionEnabled = isEnabled
    }
    
    func setHeader(headerContext: ContextMenuProviderProtocol) {
        self.headerContext = headerContext
        if let topView = topView() {
            topView.setupTitle(title: headerContext.title)
            topView.setupOnContext(callback: headerContext.hasContextMenu()
                                   ? { [weak self] in self?.presenter.openContextMenu() }
                                   : nil)
            if navigationController?.viewControllers.count ?? 0 > 1 {
                topView.setupOnClose(callback: { [weak self] in
                    self?.closeModule(animated: true)
                })
            }
        }
    }
    
    func inputFieldsWasUpdated() {
        conditionViews.forEach { $0.updateConditions(inputFields: inputViews) }
    }
    
    func getInputData() -> [String: AnyCodable] {
        var dict: [String: AnyCodable] = [:]
        inputViews.forEach { inputView in
            if inputView.isVisible() {
                dict[inputView.inputCode()] = inputView.inputData()
            }
        }
        return dict
    }
    
    func screenCode() -> String {
        return presenter.screenCode()
    }
    
    func resourceId() -> String? {
        return presenter.resourceId()
    }
}

extension ConstructorPaginationScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstructorPaginationContainerCell.reuseID, for: indexPath) as? ConstructorPaginationContainerCell
        else {
            return ConstructorPaginationContainerCell()
        }
        if indexPath.row == bodyViews.count {
            presenter.didScrollToEnd()
        }
        let view = bodyViews[indexPath.row]
        cell.setSubview(view)
        return cell
    }
}

private extension ConstructorPaginationScreenViewController {
    enum Constants {
        static let keyboardSpacing: CGFloat = 8
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 62)
        static let loadingHeight: CGFloat = 56
    }
}
