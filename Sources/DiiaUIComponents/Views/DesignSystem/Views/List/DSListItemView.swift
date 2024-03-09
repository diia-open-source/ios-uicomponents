import UIKit
import DiiaCommonTypes

public class DSListItemViewModel: NSObject {
    public let id: String?
    public let leftBigIcon: UIImage?
    @objc public dynamic var leftSmallIcon: UIImage?
    @objc public dynamic var isLoading: Bool
    public let title: String
    public let details: String?
    public let rightIcon: UIImage?
    public let isEnabled: Bool
    public var onClick: Callback?
    
    public init(id: String? = nil,
                leftBigIcon: UIImage? = nil,
                leftSmallIcon: UIImage? = nil,
                title: String,
                details: String? = nil,
                rightIcon: UIImage? = nil,
                isEnabled: Bool = true,
                onClick: @escaping Callback = {}
    ) {
        self.id = id
        self.leftBigIcon = leftBigIcon
        self.leftSmallIcon = leftSmallIcon
        self.title = title
        self.details = details
        self.rightIcon = rightIcon
        self.isEnabled = isEnabled
        self.onClick = onClick
        self.isLoading = false
    }
}

public class DSListItemView: BaseCodeView {
    private let leftBigIconView: UIImageView = UIImageView().withSize(Constants.bigIconSize)
    private let leftSmallIconView: UIImageView = UIImageView().withSize(Constants.smallIconSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .statusGray)
    private let rightIconView: UIImageView = UIImageView().withSize(Constants.smallIconSize)
    
    private var stackAnchors: AnchoredConstraints?
    private var onClickHandler: Callback?
    private var viewModel: DSListItemViewModel?
    private var loadingObservation: NSKeyValueObservation?
    private var smallIconObservation: NSKeyValueObservation?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView.create(
            .horizontal,
            views: [
                leftBigIconView,
                leftSmallIconView,
                UIStackView.create(
                    views: [
                        titleLabel,
                        detailsLabel
                    ],
                    spacing: Constants.textsSpacing),
                rightIconView
            ],
            spacing: Constants.stackSpacing,
            alignment: .center)
        
        addSubview(stackView)
        stackAnchors = stackView.fillSuperview(padding: Constants.defaultStackPadding)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        setupAccessibility()
    }
    
    // MARK: - Public Methods
    public func setupUI(stackPadding: UIEdgeInsets) {
        stackAnchors?.top?.constant = stackPadding.top
        stackAnchors?.leading?.constant = stackPadding.left
        stackAnchors?.bottom?.constant = stackPadding.bottom
        stackAnchors?.trailing?.constant = stackPadding.right
        layoutIfNeeded()
    }
    
    public func configure(viewModel: DSListItemViewModel) {
        self.viewModel = viewModel
        leftBigIconView.image = viewModel.leftBigIcon
        leftBigIconView.isHidden = viewModel.leftBigIcon == nil
        titleLabel.text = viewModel.title
        detailsLabel.text = viewModel.details
        detailsLabel.isHidden = viewModel.details == nil
        rightIconView.image = viewModel.rightIcon
        rightIconView.isHidden = viewModel.rightIcon == nil
        onClickHandler = viewModel.onClick
        
        accessibilityLabel = viewModel.accessibilityLabel
        accessibilityIdentifier = viewModel.id
        
        isUserInteractionEnabled = viewModel.isEnabled
        alpha = viewModel.isEnabled ? 1 : 0.3
        
        smallIconObservation = viewModel.observe(\.leftSmallIcon, onChange: { [weak self] image in
            self?.leftSmallIconView.image = image
            self?.leftSmallIconView.isHidden = image == nil
        })
        
        loadingObservation = viewModel.observe(\.isLoading, onChange: { [weak self] isLoading in
            guard let self = self else { return }
            self.updateState(isLoading: isLoading)
        })
    }

    // MARK: - Private Methods
    private func updateState(isLoading: Bool) {
        if isLoading {
            leftSmallIconView.image = R.image.gradientCircleWithInsets.image
            leftSmallIconView.startRotating()
        } else {
            leftSmallIconView.image = viewModel?.leftSmallIcon
            leftSmallIconView.stopRotation()
        }
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    @objc private func onClick() {
        onClickHandler?()
    }
}

private extension DSListItemView {
    enum Constants {
        static let bigIconSize = CGSize(width: 32, height: 32)
        static let smallIconSize = CGSize(width: 24, height: 24)
        static let stackSpacing: CGFloat = 16
        static let textsSpacing: CGFloat = 4
        static let defaultStackPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}
