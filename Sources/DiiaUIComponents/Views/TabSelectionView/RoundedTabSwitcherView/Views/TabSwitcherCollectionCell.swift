
import UIKit

public final class TabSwitcherCollectionCell: BaseCollectionNibCell {
    
    private var titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private var additionalLabel = UILabel().withParameters(font: FontBook.tabBarTitle,
                                                           textColor: .white)
    private var additionalBox = UIView()
    private var additionConstraint: NSLayoutConstraint?
    private var titleConstraint: NSLayoutConstraint?
    
    var isSelectedState: Bool = false {
        didSet {
            contentView.backgroundColor = isSelectedState ? .white : Constants.unselectedItem
            accessibilityTraits = isSelectedState ? [.selected, .button] : [.button]
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAccessibility()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        setupAccessibility()
    }
    
    private func setupSubviews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalBox.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        additionalBox.addSubview(additionalLabel)
        contentView.addSubview(additionalBox)
        additionalLabel.fillSuperview(padding: Constants.additionalInsets)
        
        additionalBox.backgroundColor = .black
        additionalBox.layer.cornerRadius = Constants.additionalHeight / 2.0
        additionalBox.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Constants.labelPadding.left),
            
            additionalBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            additionalBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Constants.labelPadding.right),
        ])
        
        additionConstraint = titleLabel.trailingAnchor.constraint(equalTo: additionalBox.leadingAnchor,
                                                                  constant: -Constants.additionalInsets.left)
        titleConstraint = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                               constant: -Constants.labelPadding.right)
        titleConstraint?.isActive = true
        additionalBox.withHeight(Constants.additionalHeight)
        
        contentView.layer.cornerRadius = frame.height / 2.0
        contentView.layer.masksToBounds = true
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        additionalLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Public methods
    public func configure(tabItem: TabSwitcherModel, additionalText: String? = nil) {
        titleLabel.text = tabItem.title
        isSelectedState = tabItem.isSelected
        let hasAdditionalText = !(additionalText == nil)
        additionalBox.isHidden = !hasAdditionalText
        additionalLabel.text = additionalText
        titleConstraint?.isActive = !hasAdditionalText
        additionConstraint?.isActive = hasAdditionalText
        
        accessibilityLabel = tabItem.title
        accessibilityValue = additionalText
        
        setNeedsLayout()
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: layoutAttributes.frame.height)
        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel, verticalFittingPriority: UILayoutPriority.required)
        autoLayoutAttributes.frame.size.width = ceil(autoLayoutSize.width)
        return autoLayoutAttributes
    }
}

private extension TabSwitcherCollectionCell {
    struct Constants {
        static let stackSpacing: CGFloat = 6
        static let additionalHeight: CGFloat = 18
        static let unselectedItem = UIColor(white: 1, alpha: 0.3)
        static let labelPadding = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        static let additionalInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
}
