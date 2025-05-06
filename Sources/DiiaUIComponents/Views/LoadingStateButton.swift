import UIKit

open class LoadingStateButton: UIButton {

    // MARK: - LoadingState
    public enum LoadingState {
        case loadedWithCheckmark
        case loadedWithArrow
        case disabled
        case enabled
        case loading
    }
    
    // MARK: - Properties
    public private(set) var loadingState: LoadingState = .enabled
    private var buttonStyle: LoadingStateButtonStyle = .solid
        
    private lazy var loadingImageView: AnimationView = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(size: Constants.loadingViewSize, loadingImage: R.image.gradienCircle.image)
        let animationView = AnimationView(loadingContainer)
        animationView.isHidden = true
        initialSetup(forLeftView: animationView)
        return animationView
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
    
    public func setStyle(style: LoadingStateButtonStyle) {
        self.buttonStyle = style
        updateColors()
    }
    
    private func setStyleConfiguration(configuration: ButtonStyleConfiguration) {
        backgroundColor = configuration.backgroundColor
        setTitleColor(configuration.titleColor, for: .normal)
        if let icon = configuration.icon {
            setImage(icon, for: .normal)
        }
        if let borderColor = configuration.borderColor,
           let borderWidth = configuration.borderWidth,
           borderWidth > 0 {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
    
    // MARK: - Private Methods
    private func updateColors() {
        switch loadingState {
        case .disabled:
            setStyleConfiguration(configuration: buttonStyle.disabledStyle)
        case .enabled:
            setStyleConfiguration(configuration: buttonStyle.enabledStyle)
        case .loading:
            setStyleConfiguration(configuration: buttonStyle.loadingStyle)
        case .loadedWithCheckmark, .loadedWithArrow:
            self.backgroundColor = UIColor(AppConstants.Colors.sendCopiesSuccess)
            self.setTitleColor(.white, for: .normal)
            self.layer.borderColor = UIColor(AppConstants.Colors.sendCopiesSuccess).cgColor
        }
    }
    
    private func updateUserInteraction() {
        switch loadingState {
        case .enabled, .loadedWithArrow:
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
        case .loadedWithCheckmark, .enabled, .loadedWithArrow, .disabled:
            delay = 0
            shouldBeHidden = true
            loadingImageView.isHidden = true
        case .loading:
            delay = Constants.appearingDelay
            shouldBeHidden = false
            loadingImageView.isHidden = false
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
        static let loadingViewSize = CGSize(width: 16, height: 16)
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
        case .enabled: return .enabled
        case .loading: return .loading
        }
    }
}

public struct ButtonStyleConfiguration {
    public let backgroundColor: UIColor
    public let titleColor: UIColor
    public let borderColor: UIColor?
    public let borderWidth: CGFloat?
    public let icon: UIImage?
    
    public init(backgroundColor: UIColor, titleColor: UIColor, borderColor: UIColor? = nil, borderWidth: CGFloat = 0, icon: UIImage? = nil) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.icon = icon
    }
}

public struct LoadingStateButtonStyle {
    public static let solid = LoadingStateButtonStyle(
        enabledStyle: .init(backgroundColor: .black, titleColor: .white),
        loadingStyle: .init(backgroundColor: .black, titleColor: .white),
        disabledStyle: .init(backgroundColor: .black.withAlphaComponent(Constants.disabledAlpha), titleColor: .white)
    )
    public static let plain = LoadingStateButtonStyle(
        enabledStyle: .init(backgroundColor: .clear, titleColor: .black),
        loadingStyle: .init(backgroundColor: .clear, titleColor: .black),
        disabledStyle: .init(backgroundColor: .clear, titleColor: .black.withAlphaComponent(Constants.disabledAlpha))
    )
    public static let light = LoadingStateButtonStyle(
        enabledStyle: .init(backgroundColor: .clear, titleColor: .black, borderColor: .black, borderWidth: Constants.borderWidth),
        loadingStyle: .init(backgroundColor: .clear, titleColor: .black, borderColor: .black, borderWidth: Constants.borderWidth),
        disabledStyle: .init(backgroundColor: .clear, titleColor: .black.withAlphaComponent(Constants.disabledAlpha), borderColor: .black.withAlphaComponent(Constants.disabledAlpha), borderWidth: Constants.borderWidth)
    )
    public static let white = LoadingStateButtonStyle(
        enabledStyle: .init(backgroundColor: .white, titleColor: .black),
        loadingStyle: .init(backgroundColor: .white, titleColor: .black),
        disabledStyle: .init(backgroundColor: .white.withAlphaComponent(Constants.disabledAlpha), titleColor: .black.withAlphaComponent(Constants.disabledAlpha))
    )
    public static let whiteBordered = LoadingStateButtonStyle(
        enabledStyle: .init(backgroundColor: .clear, titleColor: .white, borderColor: .white, borderWidth: Constants.borderWidth),
        loadingStyle: .init(backgroundColor: .clear, titleColor: .white, borderColor: .white, borderWidth: Constants.borderWidth),
        disabledStyle: .init(backgroundColor: .clear, titleColor: .white.withAlphaComponent(Constants.disabledAlpha), borderColor: .white.withAlphaComponent(Constants.disabledAlpha), borderWidth: Constants.borderWidth)
    )

    public let enabledStyle: ButtonStyleConfiguration
    public let loadingStyle: ButtonStyleConfiguration
    public let disabledStyle: ButtonStyleConfiguration
    
    init(enabledStyle: ButtonStyleConfiguration,
         loadingStyle: ButtonStyleConfiguration,
         disabledStyle: ButtonStyleConfiguration
    ) {
        self.enabledStyle = enabledStyle
        self.loadingStyle = loadingStyle
        self.disabledStyle = disabledStyle
    }
    
    private enum Constants {
        static let disabledAlpha: CGFloat = 0.1
        static let borderWidth: CGFloat = 2
    }
}
