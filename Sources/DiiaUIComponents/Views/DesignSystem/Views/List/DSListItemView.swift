
import UIKit
import DiiaCommonTypes

public final class DSListItemViewModel: NSObject {
    public let id: String?
    public let leftBase64Icon: UIImage?
    public let leftBigIcon: UIImage?
    public let leftLogoLink: String?
    @objc public dynamic var leftSmallIcon: UIImage?
    @objc public dynamic var isLoading: Bool
    public let chipStatusAtm: DSCardStatusChipModel?
    public let amountAtm: DSAmountAtmModel?
    public let title: String
    public let details: String?
    public let rightIcon: UIImage?
    public let componentId: String?
    @objc public dynamic var accessibilityDescription: String?
    @objc public dynamic var isEnabled: Bool
    public let detailsParameters: [TextParameter]?
    public var onClick: Callback?
    
    public init(id: String? = nil,
                leftBigIcon: UIImage? = nil,
                leftLogoLink: String? = nil,
                leftBase64Icon: UIImage? = nil,
                leftSmallIcon: UIImage? = nil,
                title: String,
                details: String? = nil,
                rightIcon: UIImage? = nil,
                isEnabled: Bool = true,
                componentId: String? = nil,
                accessibilityDescription: String? = nil,
                chipStatusAtm: DSCardStatusChipModel? = nil,
                amountAtm: DSAmountAtmModel? = nil,
                detailsParameters: [TextParameter]? = nil,
                onClick: Callback? = nil
    ) {
        self.id = id
        self.leftBase64Icon = leftBase64Icon
        self.leftBigIcon = leftBigIcon
        self.leftLogoLink = leftLogoLink
        self.leftSmallIcon = leftSmallIcon
        self.title = title
        self.details = details
        self.rightIcon = rightIcon
        self.isEnabled = isEnabled
        self.onClick = onClick
        self.componentId = componentId
        self.accessibilityDescription = accessibilityDescription
        self.chipStatusAtm = chipStatusAtm
        self.amountAtm = amountAtm
        self.isLoading = false
        self.detailsParameters = detailsParameters
    }
    
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(id)
        hasher.combine(title)
        return hasher.finalize()
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DSListItemViewModel else { return false }
        return self.id == other.id && self.title == other.title
    }
}

public final class DSListItemView: BaseCodeView {
    private let leftBase64IconView: UIImageView = UIImageView().withSize(Constants.bigIconSize)
    private let leftBigIconView: UIImageView = UIImageView().withSize(Constants.bigIconSize)
    private let leftSmallIconView: UIImageView = UIImageView().withSize(Constants.smallIconSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText,
                                                      lineBreakMode: .byTruncatingTail)
    private let detailsTextView = UITextView()
    private let rightIconView: UIImageView = UIImageView().withSize(Constants.smallIconSize)
    private lazy var chipStatusView = DSChipStatusAtmView()
    private lazy var amountView = DSAmountAtm()
    private let leftLogoLinkView = DSLogoLinkView().withSize(Constants.bigIconSize)
    private var mainStackView: UIStackView = UIStackView()
    
    private var stackAnchors: AnchoredConstraints?
    
    private var viewModel: DSListItemViewModel?
    
    private var onClickHandler: Callback?
    
    private var loadingObservation: NSKeyValueObservation?
    private var smallIconObservation: NSKeyValueObservation?
    private var isEnabledObservation: NSKeyValueObservation?
    private var accessibilityDescriptionObservation: NSKeyValueObservation?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        mainStackView = UIStackView.create(
            .horizontal,
            views: [
                leftBase64IconView,
                leftLogoLinkView,
                leftBigIconView,
                leftSmallIconView,
                UIStackView.create(
                    views: [
                        titleLabel,
                        detailsTextView,
                        chipStatusView
                    ],
                    spacing: Constants.textsSpacing),
                rightIconView,
                amountView
            ],
            spacing: Constants.stackSpacing,
            alignment: .center)
        
        addSubview(mainStackView)
        stackAnchors = mainStackView.fillSuperview(padding: Constants.defaultStackPadding)
        
        detailsTextView.font = FontBook.usualFont
        detailsTextView.textColor = .black540
        detailsTextView.textContainer.lineBreakMode = .byTruncatingTail
        detailsTextView.configureForParametrizedText()
        detailsTextView.setContentCompressionResistancePriority(.required, for: .horizontal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    // MARK: - Public Methods
    public func setupUI(stackPadding: UIEdgeInsets) {
        stackAnchors?.top?.constant = stackPadding.top
        stackAnchors?.leading?.constant = stackPadding.left
        stackAnchors?.bottom?.constant = -stackPadding.bottom
        stackAnchors?.trailing?.constant = -stackPadding.right
        layoutIfNeeded()
    }
    
    public func configureUI(
        titleLines: Int = 3,
        detailsLines: Int = 2,
        stackAlign: UIStackView.Alignment = .center
    ) {
        titleLabel.numberOfLines = titleLines
        detailsTextView.textContainer.maximumNumberOfLines = detailsLines
        mainStackView.alignment = stackAlign
    }
    
    public func configure(viewModel: DSListItemViewModel) {
        self.viewModel = viewModel
        self.accessibilityIdentifier = viewModel.componentId
        leftBase64IconView.image = viewModel.leftBase64Icon
        leftBase64IconView.isHidden = viewModel.leftBase64Icon == nil
        
        leftBigIconView.image = viewModel.leftBigIcon
        leftBigIconView.isHidden = viewModel.leftBigIcon == nil
 
        titleLabel.text = viewModel.title
        
        detailsTextView.attributedText = viewModel.details?.attributedTextWithParameters(parameters: viewModel.detailsParameters)
        detailsTextView.isHidden = viewModel.details == nil
        
        rightIconView.image = viewModel.rightIcon
        rightIconView.isHidden = viewModel.rightIcon == nil
        onClickHandler = viewModel.onClick
        
        chipStatusView.isHidden = viewModel.chipStatusAtm == nil
        if let chipStatusAtm = viewModel.chipStatusAtm {
            chipStatusView.configure(for: chipStatusAtm)
        }
        
        leftLogoLinkView.isHidden = viewModel.leftLogoLink == nil
        if let link = viewModel.leftLogoLink {
            leftLogoLinkView.configure(with: link)
        }
        
        amountView.isHidden = viewModel.amountAtm == nil
        if let amountAtm = viewModel.amountAtm {
            amountView.configure(with: amountAtm, textAlignment: .right)
        }
        
        accessibilityIdentifier = viewModel.componentId
        
        smallIconObservation = viewModel.observe(\.leftSmallIcon, onChange: { [weak self] image in
            self?.leftSmallIconView.image = image
            self?.leftSmallIconView.isHidden = image == nil
        })
        
        loadingObservation = viewModel.observe(\.isLoading, onChange: { [weak self] isLoading in
            guard let self = self else { return }
            self.updateState(isLoading: isLoading)
        })
        
        isEnabledObservation = viewModel.observe(\.isEnabled, onChange: { [weak self] isEnabled in
            guard let self = self else { return }
            self.isUserInteractionEnabled = isEnabled
            self.alpha = isEnabled ? 1 : Constants.disabledAlpha
        })
        
        accessibilityDescriptionObservation = viewModel.observe(\.accessibilityDescription, onChange: { [weak self] accessibilityDescription in
            guard let self else { return }
            
            self.accessibilityLabel = accessibilityDescription
        })
        
        setupAccessibility()
    }

    // MARK: - Private Methods
    private func updateState(isLoading: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            if isLoading {
                self.leftSmallIconView.image = R.image.gradientCircleWithInsets.image
                self.leftSmallIconView.isHidden = false
                self.leftSmallIconView.startRotating()
            } else {
                self.leftSmallIconView.isHidden = self.viewModel?.leftSmallIcon == nil
                self.leftSmallIconView.image = self.viewModel?.leftSmallIcon
                self.leftSmallIconView.stopRotation()
            }
        }
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        if let accessibilityDescription = viewModel?.accessibilityDescription {
            accessibilityLabel = accessibilityDescription
        } else {
            accessibilityLabel = "\(viewModel?.title ?? "") \(viewModel?.details ?? "") \(viewModel?.amountAtm?.value ?? ""). \(viewModel?.chipStatusAtm?.name ?? "")"
        }
        accessibilityTraits = (viewModel?.onClick != nil) ? .button : .staticText
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
        static let textsSpacing: CGFloat = 8
        static let defaultStackPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let disabledAlpha: CGFloat = 0.3
        static let animationDuration: CGFloat = 0.15
    }
}
