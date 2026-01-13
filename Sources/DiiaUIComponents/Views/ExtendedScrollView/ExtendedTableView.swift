
import UIKit

public final class ExtendedTableView: UITableView {
    // MARK: - UI Elements
    private let bottomSeparator = UIView()
    private let gradientView = GradientView()
    
    // MARK: - Properties
    public var bottomPadding: CGFloat = 0
    public var separatorShouldAlwaysBeVisible: Bool = false
    
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
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Public Methods    
    func updateSeparatorVisibility() {
        if separatorShouldAlwaysBeVisible {
            bottomSeparator.isHidden = false
        } else {
            let bottomPadding = bottomPadding + Constants.separatorHeight
            let contentOffset = self.contentOffset.y + self.bounds.height + bottomPadding
            bottomSeparator.isHidden = self.contentSize.height <= contentOffset
        }
    }
    
    public func addBottomGradient() {
        guard let superview = self.superview else { return }
        superview.addSubview(gradientView)
        gradientView.anchor(top: nil, leading: self.leadingAnchor, bottom: bottomSeparator.topAnchor, trailing: self.trailingAnchor, size: CGSize(width: 0, height: Constants.gradientViewHeight))
    }
    
    // MARK: - Private Methods
    private func setupView() {
        addSeparator()
    }
    
    private func addSeparator() {
        guard let superview = self.superview else { return }
        bottomSeparator.backgroundColor = Constants.separatorColor
        superview.addSubview(bottomSeparator)
        bottomSeparator.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, size: CGSize(width: 0, height: Constants.separatorHeight))
    }
}

// MARK: - Constants
extension ExtendedTableView {
    private enum Constants {
        static var separatorColor = UIColor(AppConstants.Colors.separatorColor)
        static var separatorHeight: CGFloat = 2
        static var gradientViewHeight: CGFloat = 40
    }
}
