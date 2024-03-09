import UIKit

class RoundedTabSwitcherCollectionCell: BaseCollectionNibCell, NibLoadable {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var checkboxIcon: UIImageView!
    var isSelectedState: Bool = false {
        didSet {
            containerView.backgroundColor = isSelectedState ? .white : Constants.unselectedItem
            checkboxIcon.isHidden = !isSelectedState
        }
    }
    
    static func widthForVM(viewModel: TabSwitcherModel) -> CGFloat {
        let calculatedWidth: CGFloat = viewModel.title.size(withAttributes: [NSAttributedString.Key.font: FontBook.usualFont]).width + Constants.overallIndent
        return viewModel.isSelected  ? calculatedWidth + Constants.counterViewWidth : calculatedWidth
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = frame.height / 2
    }
    
    func configure(tabItem: TabSwitcherModel) {
        titleLabel.text = tabItem.title
        isSelectedState = tabItem.isSelected
    }
    
    private func setupUI() {
        titleLabel.font = FontBook.usualFont
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        containerView.layer.cornerRadius = frame.height / 2
        containerView.layer.masksToBounds = true
    }
}

private extension RoundedTabSwitcherCollectionCell {
    struct Constants {
        static let unselectedItem = UIColor(white: 1, alpha: 0.3)
        static let overallIndent: CGFloat = 36
        static let counterViewWidth: CGFloat = 30
    }
}
