
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public protocol ConstructorModalScreenPresenter: BasePresenter {
    func handleEvent(event: ConstructorItemEvent)
}

public protocol ConstructorModalScreenViewProtocol: BaseView {
    func setLoadingState(_ state: LoadingState)
    func setInnerTridentLoading(_ state: LoadingState)
    func configure(model: DSConstructorModel)
    func inputFieldsWasUpdated()
    func setUserInteractionEnabled(_ isEnabled: Bool)
    func getInputData() -> [String: AnyCodable]
    func setFabric(_ fabric: DSViewFabric)
    func modify(_ modifier: ConstructorViewModifier)
}

public final class ConstructorModalViewController: UIViewController {
    
    private var constructorView: ConstructorModalView? { view as? ConstructorModalView }
    
    // MARK: - Properties
    public var presenter: ConstructorModalScreenPresenter!

    private var viewFabric = DSViewFabric.instance
    private var keyboardHandler: KeyboardHandler?

    private var headerContext: ContextMenuProviderProtocol?
    private var inputViews: [DSInputComponentProtocol] = []
    private var conditionViews: [DSConditionComponentProtocol] = []
    private var scrollDependentViews: [ScrollDependentComponentProtocol] = []
    
    // MARK: - Init
    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    public override func loadView() {
        super.loadView()
        
        let view = ConstructorModalView(frame: UIScreen.main.bounds)
        view.bodyScrollView.delegate = self
        self.view = view
        self.view.backgroundColor = UIColor(AppConstants.Colors.emptyDocuments)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        constructorView?.setupCloseAction(action: Action(
            image: R.image.closeBtn.image,
            callback: { [weak self] in
                self?.closeModule(animated: true)
            }))
        constructorView?.bodyScrollView.keyboardDismissMode = .onDrag

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        presenter.configureView()
    }
    
    // MARK: - Private
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - View logic
extension ConstructorModalViewController: ConstructorModalScreenViewProtocol {
    public func setLoadingState(_ state: LoadingState) {
        constructorView?.setupLoading(isActive: state == .loading)
    }
    
    public func setInnerTridentLoading(_ state: LoadingState) {
        constructorView?.bodyStack.isHidden = state == .loading
        constructorView?.bottomStack.isHidden = state == .loading
        constructorView?.loadingView.setLoadingState(state)
    }
    
    public func configure(model: DSConstructorModel) {
        let eventHandler: (ConstructorItemEvent) -> Void = { [weak self] event in
            self?.presenter.handleEvent(event: event)
        }
        
        let topViews = viewFabric.topGroupViews(for: model, eventHandler: eventHandler)
        let bodyViews = viewFabric.bodyViews(for: model, eventHandler: eventHandler)
        let bottomView = viewFabric.bottomGroupViews(for: model, eventHandler: eventHandler)
        
        constructorView?.setupTopGroup(views: topViews)
        constructorView?.setupBody(views: bodyViews)
        constructorView?.setupBottomGroup(views: bottomView)
        
        self.conditionViews = view.findTypedSubviews()
        self.inputViews = view.findTypedSubviews()
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
            keyboardHandler = .init(type: .constraint(
                constraint: bottomConstraint,
                withoutInset: bottomConstraint.constant,
                keyboardInset: Constants.keyboardSpacing + view.safeAreaInsets.bottom,
                superview: constructorView))
        }
        
        
        if !scrollDependentViews.isEmpty, let scrollView = constructorView?.bodyScrollView {
            scrollViewDidScroll(scrollView)
        }
        
        self.inputFieldsWasUpdated()
    }
    
    public func inputFieldsWasUpdated() {
        conditionViews.forEach { $0.updateConditions(inputFields: inputViews) }
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
    
    public func setUserInteractionEnabled(_ isEnabled: Bool) {
        constructorView?.bodyStack.isUserInteractionEnabled = isEnabled
        constructorView?.bottomStack.isUserInteractionEnabled = isEnabled
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        viewFabric = fabric
    }
    
    public func modify(_ modifier: any ConstructorViewModifier) {
        modifier.modify(viewController: self)
    }
}

extension ConstructorModalViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDependentViews.forEach { $0.scrollViewDidScroll(scrollView: scrollView) }
    }
}

private extension ConstructorModalViewController {
    enum Constants {
        static let offset: CGFloat = 32
        static let keyboardSpacing: CGFloat = 8
    }
}
