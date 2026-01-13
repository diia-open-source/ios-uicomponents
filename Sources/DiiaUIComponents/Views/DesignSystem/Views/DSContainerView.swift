
import DiiaCommonTypes
import UIKit

public final class DSContainerViewModel {
    public let items: Observable<[AnyCodable]> = .init(value: [])
    public let componentId: String?
    public let eventHandler: (ConstructorItemEvent) -> Void
    public let isLoading: Observable<Bool> = .init(value: false)
    
    public init(subviews: [AnyCodable],
                componentId: String?,
                eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.items.value = subviews
        self.componentId = componentId
        self.eventHandler = eventHandler
    }
}

/// design_system_code: updatedContainerOrg
public final class DSContainerView: BaseCodeView {
    
    private let inputFieldsStack = UIStackView.create(spacing: Constants.stackSpacing)
    
    private var viewFabric = DSViewFabric.instance
    private var viewModel: DSContainerViewModel?
    
//    private var conditionViews: [DSConditionComponentProtocol] = []
//    private var inputViews: [DSInputComponentProtocol] = []
//    private var scrollDependentViews: [ScrollDependentComponentProtocol] = []
    
    private lazy var loadingView = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(loadingImage: R.image.blackGradientSpinner.image)
        let view = AnimationView(loadingContainer)
        view.frame = .init(x: 0, y: 0, width: frame.width, height: Constants.loadingHeight)
        return view
    }()
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(loadingView)
        loadingView.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           trailing: trailingAnchor,
                           padding: .allSides(Constants.contentPadding),
                           size: .init(width: .zero, height: Constants.loadingHeight))
        loadingView.isHidden = true
        
        addSubview(inputFieldsStack)
        inputFieldsStack.fillSuperview()
    }
    
    public func configure(for model: DSContainerViewModel) {
        accessibilityIdentifier = model.componentId
        inputFieldsStack.safelyRemoveArrangedSubviews()
        setupObserver(viewModel: model)
    }
    
    private func setupObserver(viewModel: DSContainerViewModel) {
        self.viewModel?.items.removeObserver(observer: self)
        viewModel.items.observe(observer: self) { [weak self, weak viewFabric, weak viewModel] subviews in
            guard let self, let viewFabric, let viewModel else { return }
            self.inputFieldsStack.safelyRemoveArrangedSubviews()
            for subview in subviews {
                if let subview = viewFabric.makeView(from: subview,
                                                     withPadding: .default,
                                                     eventHandler: viewModel.eventHandler) {
                    self.inputFieldsStack.addArrangedSubview(subview)
                }
            }
//            self.inputViews = self.findTypedSubviews()
//            self.conditionViews = self.findTypedSubviews()
//            self.scrollDependentViews = self.findTypedSubviews()
        }
        self.viewModel?.isLoading.removeObserver(observer: self)
        viewModel.isLoading.observe(observer: self) { [weak self] isLoading in
            self?.loadingView.isHidden = !isLoading
            self?.inputFieldsStack.isHidden = isLoading
        }
        viewModel.eventHandler(.onComponentConfigured(with: .containerView(viewModel: viewModel)))
        self.viewModel = viewModel
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
}

// TODO: Maybe need for future
//extension DSContainerView: DSInputComponentProtocol, DSConditionComponentProtocol, ScrollDependentComponentProtocol {
////    DSInputComponentProtocol
//    public func isValid() -> Bool {}
//    public func inputData() -> AnyCodable? {}
//    public func inputCode() -> String {}
//    
////    DSConditionComponentProtocol
//    public func updateConditions(inputFields: [any DSInputComponentProtocol]) {}
//    
////    ScrollDependentComponentProtocol
//    public func scrollViewDidScroll(scrollView: UIScrollView) {}
//}

extension DSContainerView {
    enum Constants {
        static let contentPadding: CGFloat = 16
        static let stackSpacing: CGFloat = 0
        static let loadingHeight: CGFloat = 56
    }
}
