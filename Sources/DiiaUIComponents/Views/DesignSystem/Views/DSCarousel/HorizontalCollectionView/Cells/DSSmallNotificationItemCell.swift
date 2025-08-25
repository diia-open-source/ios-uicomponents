
import UIKit
import DiiaCommonTypes

public class DSSmallNotificationItemViewModel {
    public let label: String
    public let text: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let smallIconUrlAtm: DSIconUrlAtmModel?
    public let touchAction: Callback?
    
    public init(model: DSSmallNotificationCarouselItemModel, touchAction: Callback? = nil) {
        self.label = model.label
        self.text = model.text
        self.chipStatusAtm = model.chipStatusAtm
        self.smallIconUrlAtm = model.smallIconUrlAtm
        self.touchAction = touchAction
    }
}

/// design_system_code: smallNotificationMlc
final public class DSSmallNotificationItemCell: UICollectionViewCell, Reusable {
    
    // MARK: - Subviews
    private let smallIconUrlImage = DSIconUrlAtmView()
    private let chipStatusView = DSChipView()
    private let titleLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        numberOfLines: Constants.titleNumberOfLines,
        lineBreakMode: .byTruncatingTail
    )
    private let detailsLabel = UILabel().withParameters(
        font: FontBook.bigText,
        numberOfLines: Constants.detailsNumberOfLines,
        lineBreakMode: .byTruncatingTail
    )
    
    // MARK: - Properties
    private var viewModel: DSSmallNotificationItemViewModel?
    
    // MARK: - Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSSmallNotificationItemViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.label
        detailsLabel.text = viewModel.text
        
        smallIconUrlImage.isHidden = viewModel.smallIconUrlAtm == nil
        if let smallIconModel = viewModel.smallIconUrlAtm {
            smallIconUrlImage.configure(with: smallIconModel)
        }
        chipStatusView.isHidden = viewModel.chipStatusAtm == nil
        if let chipStatusModel = viewModel.chipStatusAtm {
            chipStatusView.configure(for: chipStatusModel)
        }
        layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        let iconTitleStackView = UIStackView.create(
            .horizontal,
            views: [
                smallIconUrlImage,
                titleLabel
            ],
            spacing: Constants.topStackSpacing,
            alignment: .center)

        let topStackView = UIStackView.create(
            .horizontal,
            views: [
                iconTitleStackView,
                chipStatusView
            ],
            spacing: Constants.topStackSpacing,
            alignment: .top
        )
        let stack = UIStackView.create(
            views: [topStackView, detailsLabel],
            spacing: Constants.itemSpacing
        )
        contentView.addSubview(stack)
        stack.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: Constants.contentInsets)
        
        smallIconUrlImage.withSize(Constants.iconSize)
        chipStatusView.withHeight(Constants.chipHeight)
        chipStatusView.setContentHuggingPriority(.required, for: .horizontal)
        chipStatusView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        setupUI()
        setupAccessibility()
        addTapGestureRecognizer()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = false
        detailsLabel.isAccessibilityElement = false
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.touchAction?()
    }
}

// MARK: - Constants
extension DSSmallNotificationItemCell {
    private enum Constants {
        static let titleNumberOfLines = 2
        static let detailsNumberOfLines = 2
        static let iconSize = CGSize(width: 24, height: 24)
        static let chipHeight: CGFloat = 18
        static let topStackSpacing: CGFloat = 6
        static let itemSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
    }
}
