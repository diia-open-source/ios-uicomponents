
import UIKit

public class ExtendedScrollView: UIScrollView {
    // MARK: - UI Elements
    private var topSeparator: UIView?
    private var topGradientView: GradientView?
    private var bottomSeparator: UIView?
    private var gradientView: GradientView?
    
    // MARK: - Properties
    public var separatorShouldAlwaysBeVisible: Bool? = nil
    public var bottomSeparatorType: BottomSeparatorType = .lineWithGradient {
        didSet {
            updateSeparatorVisibility()
        }
    }
    public var topSeparatorType: BottomSeparatorType = .none {
        didSet {
            updateTopSeparatorVisibility()
        }
    }
    
    public var bottomPadding: CGFloat = 0
    
    public var separatorColor: UIColor = Constants.separatorColor {
        didSet(color) {
            bottomSeparator?.backgroundColor = color
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        addSeparator()
        addBottomGradient()
        addTopSeparator()
        addTopGradient()
        updateSeparatorVisibility()
        updateTopSeparatorVisibility()
    }
    
    // MARK: - Public Methods
    public func updateSeparatorVisibility() {
        if bottomSeparatorType == .none {
            bottomSeparator?.isHidden = true
            gradientView?.isHidden = true
            return
        }
        if separatorShouldAlwaysBeVisible == true {
            bottomSeparator?.isHidden = false
        } else if separatorShouldAlwaysBeVisible == false {
            bottomSeparator?.isHidden = true
        } else {
            let bottomPadding = bottomPadding + Constants.separatorHeight
            let contentOffset = self.contentOffset.y + self.bounds.height + bottomPadding
            bottomSeparator?.isHidden = self.contentSize.height <= contentOffset
        }
        gradientView?.isHidden = bottomSeparator?.isHidden == true || bottomSeparatorType != .lineWithGradient
    }
    
    public func updateTopSeparatorVisibility() {
        if topSeparatorType == .none {
            topSeparator?.isHidden = true
            topGradientView?.isHidden = true
            return
        }
        topSeparator?.isHidden = self.contentOffset.y <= 0
        topGradientView?.isHidden = topSeparator?.isHidden == true || topSeparatorType != .lineWithGradient
    }
    
    // MARK: - Private Methods
    public func addBottomGradient() {
        guard gradientView == nil, let superview = self.superview else { return }
        let gradientView = GradientView()
        superview.addSubview(gradientView)
        gradientView.anchor(top: nil,
                            leading: self.leadingAnchor,
                            bottom: bottomSeparator?.topAnchor ?? self.bottomAnchor,
                            trailing: self.trailingAnchor,
                            size: CGSize(width: 0, height: Constants.gradientViewHeight))
        self.gradientView = gradientView
    }
    
    public func addTopGradient() {
        guard topGradientView == nil, let superview = self.superview else { return }
        let topGradientView = GradientView()
        topGradientView.configureGradient(for: [UIColor.endGradientColor, UIColor.startGradientColor])
        superview.addSubview(topGradientView)
        topGradientView.anchor(top: topSeparator?.bottomAnchor ?? self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: nil,
                               trailing: self.trailingAnchor,
                               size: CGSize(width: 0, height: Constants.gradientViewHeight))
        self.topGradientView = topGradientView
    }
    
    public func addSeparator() {
        guard bottomSeparator == nil, let superview = self.superview else { return }
        let separator = UIView()
        separator.backgroundColor = separatorColor
        superview.addSubview(separator)
        separator.anchor(top: nil,
                         leading: self.leadingAnchor,
                         bottom: self.bottomAnchor,
                         trailing: self.trailingAnchor,
                         size: CGSize(width: 0, height: Constants.separatorHeight))
        self.bottomSeparator = separator
    }
    
    public func addTopSeparator() {
        guard topSeparator == nil, let superview = self.superview else { return }
        let separator = UIView()
        separator.backgroundColor = separatorColor
        superview.addSubview(separator)
        separator.anchor(top: self.topAnchor,
                         leading: self.leadingAnchor,
                         bottom: nil,
                         trailing: self.trailingAnchor,
                         size: CGSize(width: 0, height: Constants.separatorHeight))
        self.topSeparator = separator
    }
    
    // MARK: - Nested Objects
    public enum BottomSeparatorType {
        case none, line, lineWithGradient
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
