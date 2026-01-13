
import UIKit
import DiiaCommonTypes

public final class DSWhiteAdditionalIconButtonViewModel: NSObject {
    public let name: String?
    public let image: UIImage?
    public let componentId: String?
    public let accessibilityDescription: String?
    public var badgeCount: Observable<Int>
    public var clickHandler: Callback?
    public var isLoading: Observable<Bool>
    
    public init(name: String?,
                image: UIImage?,
                badgeCount: Observable<Int>,
                isLoading: Observable<Bool> = .init(value: false),
                componentId: String? = nil,
                accessibilityDescription: String? = nil,
                clickHandler: Callback? = nil) {
        self.name = name
        self.image = image
        self.badgeCount = badgeCount
        self.isLoading = isLoading
        self.componentId = componentId
        self.clickHandler = clickHandler
        self.accessibilityDescription = accessibilityDescription
    }
}

public final class DSWhiteAdditionalIconButton: BaseCodeView {
    private let badgeCounter = DSBadgeCounterView()
    private let label = UILabel().withParameters(font: FontBook.usualFont)
    private let iconView = UIImageView()
    private let containerView = UIView()
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .center)
    
    private weak var viewModel: DSWhiteAdditionalIconButtonViewModel?
  
    public override func setupSubviews() {
        initialSetup()
    }
    
    deinit {
        viewModel = nil
        viewModel?.isLoading.removeObserver(observer: self)
        viewModel?.badgeCount.removeObserver(observer: self)
    }
    
    public func configure(with viewModel: DSWhiteAdditionalIconButtonViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.componentId
        accessibilityLabel = viewModel.accessibilityDescription
        label.isHidden = viewModel.name == nil
        label.text = viewModel.name
        
        viewModel.badgeCount.observe(observer: self) { [weak self] count in
            let isHidden = count == 0
            self?.badgeCounter.isHidden = isHidden
            self?.badgeCounter.set(count: String(count))
            self?.accessibilityValue = isHidden ? nil : R.Strings.general_accessibility_filters_applied.formattedLocalized(arguments: count)
        }
        
        iconView.image = viewModel.image
        viewModel.isLoading.observe(observer: self) { [weak self] isLoading in
            self?.updateState(isLoading: isLoading)
        }
    }
    
    private func initialSetup() {
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.stackInsets)
        containerView.backgroundColor = .white
 
        iconView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.iconSize.height).isActive = true
        iconView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.iconSize.width).isActive = true
        iconView.contentMode = .scaleAspectFit
                               
        mainStack.addArrangedSubviews([iconView, label, badgeCounter])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
        
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = frame.height * 0.5
        containerView.clipsToBounds = true
    }
    
    private func updateState(isLoading: Bool) {
        self.isUserInteractionEnabled = !isLoading
        self.superview?.isUserInteractionEnabled = !isLoading
        if isLoading {
            iconView.image = R.image.gradientCircleWithInsets.image
            iconView.startRotating()
        } else {
            iconView.image = viewModel?.image
            iconView.stopRotation()
        }
    }
    
    @objc private func onTapped() {
        viewModel?.clickHandler?()
    }
}

extension DSWhiteAdditionalIconButton {
    private enum Constants {
        static let stackInsets: UIEdgeInsets = .init(top: 8, left: 18, bottom: 8, right: 18)
        static let iconSize: CGSize = .init(width: 24, height: 24)
        static let spacing: CGFloat = 8
    }
}
