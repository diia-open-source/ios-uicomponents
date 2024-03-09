import UIKit

public class ChecklistItemViewModel: NSObject {
    public let code: String?
    public let title: String
    public let details: String?
    public let rightInfo: String?
    public let isAvailable: Bool
    @objc public dynamic var isSelected: Bool
    public var onClick: (() -> Void)?
    
    public init(code: String? = nil,
                title: String,
                details: String? = nil,
                rightInfo: String? = nil,
                isAvailable: Bool = true,
                isSelected: Bool = false) {
        self.code = code
        self.title = title
        self.details = details
        self.rightInfo = rightInfo
        self.isAvailable = isAvailable
        self.isSelected = isSelected
    }
}

public class ChecklistItemView: BaseCodeView {
    private let selectionIcon = UIImageView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    private let rightInfoLabel = UILabel()
    
    private var observation: NSKeyValueObservation?
    private var viewModel: ChecklistItemViewModel?
    private var checkboxStyle: CheckboxStyle?
    
    public override func setupSubviews() {
        self.backgroundColor = .clear
        selectionIcon.withSize(Constants.selectionIconSize)
        setupUI(titleFont: FontBook.usualFont,
                titleColor: .black,
                detailsFont: FontBook.statusFont,
                detailsTextColor: Constants.grayTextColor,
                rightInfoFont: FontBook.usualFont,
                rightInfoColor: Constants.grayTextColor)
        
        let contentStackView = UIStackView.create(
            views: [titleLabel, detailsLabel],
            spacing: Constants.titleSpacing,
            alignment: .leading
        )
        let contentBoxView = BoxView(subview: contentStackView).withConstraints(insets: Constants.contentInsets)
        hstack(selectionIcon,
               contentBoxView,
               rightInfoLabel,
               spacing: Constants.stackViewSpacing,
               alignment: .top)
        
        addTapGestureRecognizer()
    }
    
    // MARK: - Public methods
    public func configure(with viewModel: ChecklistItemViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        detailsLabel.isHidden = viewModel.details == nil
        detailsLabel.text = viewModel.details
        rightInfoLabel.isHidden = viewModel.rightInfo == nil
        rightInfoLabel.text = viewModel.rightInfo
        
        observation = viewModel.observe(\.isSelected, onChange: { [weak self] isSelected in
            guard let self = self else { return }
            self.setSelection(state: isSelected)
        })
        
        setViewAvailability(viewModel.isAvailable)
    }
    
    public func setupUI(checkboxStyle: CheckboxStyle? = nil,
                        titleFont: UIFont? = nil,
                        titleColor: UIColor? = nil,
                        detailsFont: UIFont? = nil,
                        detailsTextColor: UIColor? = nil,
                        rightInfoFont: UIFont? = nil,
                        rightInfoColor: UIColor? = nil) {
        self.checkboxStyle = checkboxStyle
        setSelection(state: viewModel?.isSelected ?? false)
        
        titleLabel.withParameters(
            font: titleFont ?? titleLabel.font,
            textColor: titleColor ?? titleLabel.textColor
        )
        detailsLabel.withParameters(
            font: detailsFont ?? detailsLabel.font,
            textColor: detailsTextColor ?? detailsLabel.textColor
        )
        
        rightInfoLabel.textAlignment = .right
        rightInfoLabel.withParameters(
            font: rightInfoFont ?? rightInfoLabel.font,
            textColor: rightInfoColor ?? rightInfoLabel.textColor
        )
    }
    
    public func setSelection(state isSelected: Bool) {
        guard let checkboxStyle = checkboxStyle else { return }
        selectionIcon.image = isSelected ? checkboxStyle.enabledImage : checkboxStyle.disabledImage
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.onClick?()
    }
    
    // MARK: - Private methods
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    private func setViewAvailability(_ isActive: Bool) {
        self.isUserInteractionEnabled = isActive
        selectionIcon.alpha = isActive ? Constants.activeIconAlpha : Constants.inactiveIconAlpha
        setupUI(titleColor: isActive ? .black : Constants.grayTextColor)
    }
}

// MARK: - Constants
extension ChecklistItemView {
    private enum Constants {
        static let contentInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        static let selectionIconSize = CGSize(width: 20, height: 20)
        static let titleSpacing: CGFloat = 8
        static let stackViewSpacing: CGFloat = 16
        static let grayTextColor = UIColor.statusGray
        static let inactiveIconAlpha: CGFloat = 0.3
        static let activeIconAlpha: CGFloat = 1.0
    }
}
