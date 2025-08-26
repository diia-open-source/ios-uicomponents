
import UIKit

public class TabSelectionViewModel {
    let title: String
    let count: Int?
    var isSelected: Bool
    
    public init(title: String, count: Int, isSelected: Bool = false) {
        self.title = title
        self.count = count
        self.isSelected = isSelected
    }
}

public class RoundedTabSelectionCell: BaseCollectionNibCell, NibLoadable {
    // MARK: - Static
    public static let nib = UINib(nibName: reuseID, bundle: Bundle.module)

    static func widthForVM(viewModel: TabSelectionViewModel) -> CGFloat {
        let insets: CGFloat = Constants.cellHorizontalInset
        let textWidth = viewModel.title.width(
            withConstrainedHeight: .greatestFiniteMagnitude,
            font: FontBook.usualFont
        )
        
        var countAdditionalWidth: CGFloat = 0
        if let count = viewModel.count, count > 0 {
            let countWidth = String(count).width(
                withConstrainedHeight: .greatestFiniteMagnitude,
                font: FontBook.usualFont
            )
            if countWidth + Constants.countHorizontalInset > Constants.minimumCountWidth {
                countAdditionalWidth = countWidth + Constants.countHorizontalInset + Constants.stackSpacing
            } else {
                countAdditionalWidth = Constants.minimumCountWidth + Constants.stackSpacing
            }
        }
        
        return textWidth + insets + countAdditionalWidth
    }
    
    // MARK: - Outlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var counterIconView: UIView!
    public var isSelectedState: Bool = false {
        didSet {
            containerView.backgroundColor = isSelectedState ? .white : UIColor(AppConstants.Colors.uncheckedRoundTabBackgroundColor)
        }
    }

    // MARK: - LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupAccessibility()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: TabSelectionViewModel) {
        titleLabel.text = viewModel.title
        isSelectedState = viewModel.isSelected
        
        counterIconView.isHidden = viewModel.count ?? 0 == 0
        if let count = viewModel.count {
            counterLabel.text = String(count)
        }
        
        containerView.accessibilityLabel = viewModel.title
        containerView.accessibilityTraits = viewModel.isSelected ? [.selected, .button] : [.button]
    }
    
    private func setupUI() {
        titleLabel.font = FontBook.usualFont
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        counterLabel.font = FontBook.statusFont
        containerView.layer.cornerRadius = frame.height / 2
        containerView.layer.masksToBounds = true
        counterIconView.layer.cornerRadius = counterIconView.frame.height / 2
        counterIconView.layer.masksToBounds = true
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        containerView.isAccessibilityElement = true
    }
}

private extension RoundedTabSelectionCell {
    enum Constants {
        static let cellHorizontalInset: CGFloat = 32
        static let countHorizontalInset: CGFloat = 6
        static let stackSpacing: CGFloat = 8
        static let minimumCountWidth: CGFloat = 20
    }
}
