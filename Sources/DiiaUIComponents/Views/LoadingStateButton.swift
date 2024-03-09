import UIKit

open class LoadingStateButton: UIButton {

    // MARK: - LoadingState
    public enum LoadingState {
        case light
        case lightLoading
        case solid
        case solidLoading
        case loadedWithCheckmark
        case loadedWithArrow
        case disabled
        case lightDisabled
    }
    
    // MARK: - Properties
    public private(set) var loadingState: LoadingState = .light
    
    private lazy var loadingImageView: UIImageView = {
        let view = UIImageView(image: R.image.gradienCircle.image)
        initialSetup(forLeftView: view)
        
        return view
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let view = UIImageView(image: R.image.checkmarkIcon.image)
        initialSetup(forLeftView: view)
        
        return view
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView(image: R.image.forwardWhite.image)
        view.contentMode = .scaleAspectFit
        initialSetup(forRightView: view)
        
        return view
    }()
    
    private func initialSetup(forLeftView view: UIView) {
        guard let title = self.titleLabel else { return }
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        [view.heightAnchor.constraint(equalToConstant: Constants.leftViewSize),
         view.widthAnchor.constraint(equalToConstant: Constants.leftViewSize),
         view.rightAnchor.constraint(equalTo: title.leftAnchor, constant: Constants.stateViewsRightOffset),
         view.centerYAnchor.constraint(equalTo: title.centerYAnchor, constant: 0)
        ].forEach { $0.isActive = true }
         
        view.isHidden = true
    }
    
    private func initialSetup(forRightView view: UIView) {
        guard let title = self.titleLabel else { return }
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        [view.heightAnchor.constraint(equalToConstant: Constants.arrowHeight),
         view.widthAnchor.constraint(equalToConstant: Constants.arrowWidth),
         view.leftAnchor.constraint(equalTo: title.rightAnchor, constant: Constants.arrowViewRightOffset),
         view.centerYAnchor.constraint(equalTo: title.centerYAnchor, constant: 0)
        ].forEach { $0.isActive = true }
         
        view.isHidden = true
    }
    
    // MARK: - LifeCycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.height / 2
        layer.masksToBounds = true
    }
    
    // MARK: - Public Methods
    public func setLoadingState(_ state: LoadingState, withTitle title: String) {
        self.loadingState = state
        
        titleLabel?.text = title
        setTitle(title, for: .highlighted)
        setTitle(title, for: .normal)
        
        updateColors()
        updateUserInteraction()
        updateLoadingView()
        updateLoadedView()
    }

    public func setLoadingState(_ state: LoadingState) {
        loadingState = state
        
        updateColors()
        updateUserInteraction()
        updateLoadingView()
        updateLoadedView()

        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    private func updateColors() {
        let backgroundColor: UIColor
        let titleColor: UIColor
        let borderColor: UIColor
        
        switch loadingState {
        case .light, .lightLoading:
            backgroundColor = .clear
            titleColor = .black
            borderColor = .black
        case .solid, .solidLoading:
            backgroundColor = .black
            titleColor = .white
            borderColor = .black
        case .loadedWithCheckmark, .loadedWithArrow:
            backgroundColor = UIColor(AppConstants.Colors.sendCopiesSuccess)
            titleColor = .white
            borderColor = UIColor(AppConstants.Colors.sendCopiesSuccess)
        case .disabled:
            backgroundColor = UIColor.black.withAlphaComponent(Constants.disabledAlpha)
            titleColor = .white
            borderColor = UIColor.black.withAlphaComponent(Constants.disabledAlpha)
        case .lightDisabled:
            backgroundColor = .clear
            titleColor = .black.withAlphaComponent(Constants.disabledAlpha)
            borderColor = .black.withAlphaComponent(Constants.disabledAlpha)
        }
        
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
    }
    
    private func updateUserInteraction() {
        switch loadingState {
        case .solid, .light, .loadedWithArrow:
            isUserInteractionEnabled = true
        default:
            isUserInteractionEnabled = false
        }
    }
    
    private func updateLoadingView() {
        let delay: TimeInterval
        let shouldBeHidden: Bool
        
        let stateToProcessUpdating = loadingState
        
        switch stateToProcessUpdating {
        case .solid, .light, .loadedWithCheckmark, .loadedWithArrow, .disabled, .lightDisabled:
            delay = 0
            shouldBeHidden = true
            loadingImageView.stopRotation()
        case .solidLoading, .lightLoading:
            delay = Constants.appearingDelay
            shouldBeHidden = false
            loadingImageView.startRotating()
        }
        
        onMainQueueAfter(time: delay) { [weak self] in
            guard let self = self else { return }
            
            if stateToProcessUpdating == self.loadingState {
                self.loadingImageView.isHidden = shouldBeHidden
            }
        }
    }
    
    private func updateLoadedView() {
        let delay: TimeInterval
        let shouldHideCheckmark: Bool
        let shouldHideArrow: Bool
        
        let stateToProcessUpdating = loadingState
        
        switch stateToProcessUpdating {
        case .loadedWithCheckmark:
            delay = Constants.appearingDelay
            shouldHideCheckmark = false
            shouldHideArrow = true
        case .loadedWithArrow:
            delay = Constants.appearingDelay
            shouldHideCheckmark = true
            shouldHideArrow = false
        default:
            delay = 0
            shouldHideCheckmark = true
            shouldHideArrow = true
        }
        
        onMainQueueAfter(time: delay) { [weak self] in
            guard let self = self else { return }
            
            if stateToProcessUpdating == self.loadingState {
                self.checkmarkImageView.isHidden = shouldHideCheckmark
                self.arrowImageView.isHidden = shouldHideArrow
            }
        }
    }
}

// MARK: - Constants
extension LoadingStateButton {
    private enum Constants {
        static let stateViewsRightOffset: CGFloat = -9
        static let arrowViewRightOffset: CGFloat = 12
        static let appearingDelay: TimeInterval = 0.2
        static let arrowHeight: CGFloat = 12
        static let arrowWidth: CGFloat = 15
        static let disabledAlpha: CGFloat = 0.1
        static let leftViewSize: CGFloat = 18
    }
}

// MARK: - ButtonState
public enum ButtonState {
    case loading
    case enabled
    case disabled
    
    public func loadingState() -> LoadingStateButton.LoadingState {
        switch self {
        case .disabled: return .disabled
        case .enabled: return .solid
        case .loading: return .solidLoading
        }
    }
}
