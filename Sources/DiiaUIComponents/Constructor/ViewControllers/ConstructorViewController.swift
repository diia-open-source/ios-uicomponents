
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public protocol ConstructorScreenViewProtocol: BaseView {
    func setLocalLoading(isLoading: Bool)
    func setLoadingState(_ state: LoadingState)
    func setInnerTridentLoading(_ state: LoadingState)
    func setupBackground(_ background: ConstructorBackground)
    func configure(model: DSConstructorModel)
    func setHeader(headerContext: ContextMenuProviderProtocol)
    func inputFieldsWasUpdated()
    func setUserInteractionEnabled(_ isEnabled: Bool)
    func getInputData() -> [String: AnyCodable]
    func setFabric(_ fabric: DSViewFabric)
    func setConditionHandler(_ handler: ConstructorConditionHandler)
    func modify(_ modifier: ConstructorViewModifier)
    func isVisible() -> Bool
    func setCustomAccessibilityElements(elements: [Any])
    func setupBody(for model: DSConstructorModel)
    func resetBody()
}

public extension ConstructorScreenViewProtocol where Self: UIViewController {
    func isVisible() -> Bool {
        return view.window != nil
    }
}

public protocol ConstructorConditionHandler {
    func handleConditions(conditionBlocks: [DSConditionComponentProtocol], inputBlocks: [DSInputComponentProtocol])
}

public struct BaseConstructorConditionHandlerImpl: ConstructorConditionHandler {
    
    public init() { }
    
    public func handleConditions(conditionBlocks: [DSConditionComponentProtocol],
                          inputBlocks: [DSInputComponentProtocol]) {
        conditionBlocks.forEach { $0.updateConditions(inputFields: inputBlocks) }
    }
}

public enum ConstructorBackground {
    case color(UIColor)
    case image(UIImage)
}

final public class ConstructorViewController: UIViewController {
    
    private var constructorView: ConstructorScreenView? { view as? ConstructorScreenView }
    
    // MARK: - Properties
    public var presenter: ConstructorScreenPresenter!

    private var viewFabric: DSViewFabric = .instance
    private var keyboardHandler: KeyboardHandler?

    private var model: DSConstructorModel?
    private var headerContext: ContextMenuProviderProtocol?
    private var conditionViews: [DSConditionComponentProtocol] = []
    private var inputViews: [DSInputComponentProtocol] = []
    private var scrollDependentViews: [ScrollDependentComponentProtocol] = []
    private var conditionHandler: ConstructorConditionHandler = BaseConstructorConditionHandlerImpl()

    private var loadingView: LoadingView?

    // MARK: - Init
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func loadView() {
        super.loadView()
        
        let view = ConstructorScreenView(frame: UIScreen.main.bounds)
        view.bodyScrollView.delegate = self
        self.view = view
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        presenter.configureView()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if children.isEmpty {
            presenter.onViewAppear()
        }
    }

    private func initialSetup() {
        setupBackground(.color(.blackSqueeze))
        constructorView?.setupTopGroup(views: [prepareDefaultTopView()])
    }
    
    public override func canGoBack() -> Bool {
        for child in children {
            if child as? ModalPresentationViewControllerProtocol != nil {
                return false
            }
        }
        return presenter.canNavigateBack()
    }
    
    // MARK: - Accessibility
    public override func updateAccessibilityElements() {
        if children.isEmpty {
            constructorView?.updateAccessibilityElements()
        }
    }
    
    public override func removeAccessibilityElements() {
        view.accessibilityElements = nil
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
extension ConstructorViewController: ConstructorScreenViewProtocol, RatingFormHolder {
    public func setCustomAccessibilityElements(elements: [Any]) {
        constructorView?.setCustomAccessibilityElements(elements: elements)
    }
    
    public func setLoadingState(_ state: LoadingState) {
        if let topView = topView() {
            topView.setupLoading(isActive: state == .loading)
            hideProgress()
            constructorView?.bodyStack.isHidden = state == .loading
            constructorView?.bottomStack.isHidden = state == .loading
        } else {
            constructorView?.bodyStack.isHidden = false
            constructorView?.bottomStack.isHidden = false
            state == .loading ? showProgress() : hideProgress()
        }
    }
    
    public func setInnerTridentLoading(_ state: LoadingState) {
        constructorView?.bodyStack.isHidden = state == .loading
        constructorView?.bottomStack.isHidden = state == .loading
        constructorView?.loadingView.setLoadingState(state) { [weak self] in
            UIAccessibility.post(notification: .layoutChanged, argument: self?.constructorView?.topGroupStack)
        }
    }
    
    public func setLocalLoading(isLoading: Bool) {
        if isLoading {
            if loadingView == nil {
                self.loadingView = LoadingView.show(in: view)
            }
        } else {
            loadingView?.hide()
            loadingView = nil
        }
    }
    
    public func setupBackground(_ background: ConstructorBackground) {
        switch background {
        case .color(let color):
            constructorView?.backgroundImageView.image = UIImage.from(color: color)
            constructorView?.bodyScrollView.separatorColor = UIColor(AppConstants.Colors.separatorColor)
            constructorView?.bodyScrollView.bottomSeparatorType = .lineWithGradient
        case .image(let image):
            constructorView?.backgroundImageView.image = image
            constructorView?.bodyScrollView.separatorColor = .white
            constructorView?.bodyScrollView.bottomSeparatorType = .line
        }
    }
    
    public func configure(model: DSConstructorModel) {
        self.model = model
        
        let eventHandler: (ConstructorItemEvent) -> Void = { [weak self] event in
            self?.presenter.handleEvent(event: event)
        }
        
        let topViews = viewFabric.topGroupViews(for: model, eventHandler: eventHandler)
        let bodyViews = viewFabric.bodyViews(for: model, eventHandler: eventHandler)
        let centeredBodyViews = viewFabric.centeredBodyViews(for: model, eventHandler: eventHandler)
        let bottomView = viewFabric.bottomGroupViews(for: model, eventHandler: eventHandler)
        
        constructorView?.setupTopGroup(views: topViews)
        if !bodyViews.isEmpty {
            constructorView?.setupBody(views: bodyViews)
        } else {
            constructorView?.setupCenteredBody(views: centeredBodyViews)
        }
        constructorView?.setupBottomGroup(views: bottomView)
        
        self.inputViews = view.findTypedSubviews()
        self.conditionViews = view.findTypedSubviews()
        self.scrollDependentViews = view.findTypedSubviews()
        if let bodyScrollView = constructorView?.bodyScrollView {
            scrollDependentViews.forEach {
                $0.scrollViewDidScroll(scrollView: bodyScrollView)
            }
            for bodyView in bodyViews {
                if let bodyView = bodyView as? FullSizedViewProtocol {
                    bodyView.setHeightEqual(to: bodyScrollView)
                }
            }
        }
        if !inputViews.isEmpty,
           let constructorView = constructorView,
           let bottomConstraint = constructorView.bottomGroupBottomConstraint {
            keyboardHandler = .init(type: .combined(
                scrollView: constructorView.bodyScrollView,
                constraint: bottomConstraint,
                initialBottomInset: bottomConstraint.constant,
                keyboardInset: Constants.keyboardSpacing + view.safeAreaInsets.bottom,
                superview: constructorView))
        }
        
        if !scrollDependentViews.isEmpty, let scrollView = constructorView?.bodyScrollView {
            scrollViewDidScroll(scrollView)
        }
        
        inputFieldsWasUpdated()
        if let headerContext = headerContext {
            setHeader(headerContext: headerContext)
        }
    }
    
    public func setupBody(for model: DSConstructorModel) {
        let eventHandler: (ConstructorItemEvent) -> Void = { [weak self] event in
            self?.presenter.handleEvent(event: event)
        }
        
        let bodyViews = viewFabric.bodyViews(for: model, eventHandler: eventHandler)
        constructorView?.setupBody(views: bodyViews)
        
        self.inputViews = view.findTypedSubviews()
        self.conditionViews = view.findTypedSubviews()
        self.scrollDependentViews = view.findTypedSubviews()
        
        if let bodyScrollView = constructorView?.bodyScrollView {
            scrollDependentViews.forEach {
                $0.scrollViewDidScroll(scrollView: bodyScrollView)
            }
            for bodyView in bodyViews {
                if let bodyView = bodyView as? FullSizedViewProtocol {
                    bodyView.setHeightEqual(to: bodyScrollView)
                }
            }
        }
        if !inputViews.isEmpty,
           let constructorView = constructorView,
           let bottomConstraint = constructorView.bottomGroupBottomConstraint {
            keyboardHandler = .init(type: .combined(
                scrollView: constructorView.bodyScrollView,
                constraint: bottomConstraint,
                initialBottomInset: bottomConstraint.constant,
                keyboardInset: Constants.keyboardSpacing + view.safeAreaInsets.bottom,
                superview: constructorView))
        }
        
        if !scrollDependentViews.isEmpty, let scrollView = constructorView?.bodyScrollView {
            scrollViewDidScroll(scrollView)
        }
        
        inputFieldsWasUpdated()
    }
    
    public func setHeader(headerContext: ContextMenuProviderProtocol) {
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
    
    public func inputFieldsWasUpdated() {
        conditionHandler.handleConditions(conditionBlocks: conditionViews, inputBlocks: inputViews)
    }
    
    public func setUserInteractionEnabled(_ isEnabled: Bool) {
        constructorView?.bodyStack.isUserInteractionEnabled = isEnabled
        constructorView?.bottomStack.isUserInteractionEnabled = isEnabled
    }
    
    public func getInputData() -> [String: AnyCodable] {
        var dict: [String: AnyCodable] = [:]
        inputViews.forEach { inputView in
            if inputView.isVisible() {
                dict[inputView.inputCode()] = inputView.inputData()
            }
        }
        return dict
    }
    
    public func screenCode() -> String {
        return presenter.screenCode()
    }
    
    public func resourceId() -> String? {
        return presenter.resourceId()
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        viewFabric = fabric
    }
    
    public func setConditionHandler(_ handler: ConstructorConditionHandler) {
        self.conditionHandler = handler
    }
    
    public func modify(_ modifier: any ConstructorViewModifier) {
        modifier.modify(viewController: self)
    }
    
    public func resetBody() {
        guard let model else { return }
        setupBody(for: model)
    }
}

extension ConstructorViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDependentViews.forEach { $0.scrollViewDidScroll(scrollView: scrollView) }
    }
}

private extension ConstructorViewController {
    enum Constants {
        static let keyboardSpacing: CGFloat = 8
    }
}
