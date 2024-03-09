import UIKit

public class ExtendedScrollView: UIScrollView {
    // MARK: - UI Elements
    private let bottomSeparator = UIView()
    private let gradientView = GradientView()
    
    // MARK: - Properties
    public var separatorShouldAlwaysBeVisible: Bool = false
    
    public var bottomPadding: CGFloat = 0
    
    public var separatorColor: UIColor = Constants.separatorColor {
        didSet(color) {
            bottomSeparator.backgroundColor = color
        }
    }
    
    public override var contentOffset: CGPoint {
        didSet {
            updateSeparatorVisibility()
        }
    }
    
    // MARK: - Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Public Methods
    public func updateSeparatorVisibility() {
        if separatorShouldAlwaysBeVisible {
            bottomSeparator.isHidden = false
        } else {
            let bottomPadding = bottomPadding + Constants.separatorHeight
            let contentOffset = self.contentOffset.y + self.bounds.height + bottomPadding
            bottomSeparator.isHidden = self.contentSize.height <= contentOffset
        }
        gradientView.isHidden = bottomSeparator.isHidden
    }
    
    // MARK: - Private Methods
    private func setupView() {
        addSeparator()
        addBottomGradient()
    }
    
    private func addBottomGradient() {
        guard let superview = self.superview else { return }
        superview.addSubview(gradientView)
        gradientView.anchor(top: nil, leading: self.leadingAnchor, bottom: bottomSeparator.topAnchor, trailing: self.trailingAnchor, size: CGSize(width: 0, height: Constants.gradientViewHeight))
    }
    
    private func addSeparator() {
        guard let superview = self.superview else { return }
        bottomSeparator.backgroundColor = separatorColor
        superview.addSubview(bottomSeparator)
        bottomSeparator.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, size: CGSize(width: 0, height: Constants.separatorHeight))
    }
}

// MARK: - Constants
extension ExtendedScrollView {
    private enum Constants {
        static var separatorColor = UIColor(AppConstants.Colors.separatorColor)
        static var separatorHeight: CGFloat = 2
        static var gradientViewHeight: CGFloat = 40
    }
}
